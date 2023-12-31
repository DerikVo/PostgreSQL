/*
The create temp table and case portions of this query was written by Brandon Southern,
but I expanded on this query by adding a CTE and final query. 
As well as adding a join to identify the number of transactions and name of the customer,
so we can know who to target.

*/

--data param table -- create a table for the date, so we can update it as needed; can also hardcode any date instead of pulling max_date e.g. 2022-12-31
create temp table pseudo_date as(
select
	max(trans_dt) today_date
from
	transactions

)
;


-- temp table excercise
create temp table trans_w_attributes as (
	select
		t.customer_id
	  , t.transaction_id
	  , t.trans_dt
		--Finds the first transaction from a customer
	  , min(t.trans_dt) over(partition by t.customer_id) as min_cust_trans_dt
	/*
	Case statements to find if the customer bought an item in the last 30, 60, or 90 days
	*/
	  -- transactions in last 90d
	  , case when t.trans_dt >= (
									select
										today_date
									from
										pseudo_date
								) - interval '90 days'
					then 1 
					else 0 
			  end as has_trans_in_last_90d

		-- trans in last 60d
	  , case when t.trans_dt >= (
									select
										today_date
									from
										pseudo_date
								) - interval '60 days'
					then 1 
					else 0 
			  end as has_trans_in_last_60d

		-- trans in last 30d
	  , case when t.trans_dt >= (
									select
										today_date
									from
										pseudo_date
								) - interval '30 days'
					then 1 
					else 0 
			  end as has_trans_in_last_30d
	from
		transactions t
)
;

/*
	CTE query to identify what customers have a purchase in the last 90 days; following query filters for dormant accounts
*/
with purchase_in_past_90_days as (
select
	t.customer_id
  , t.transaction_id
  , t.trans_dt
  , t.min_cust_trans_dt
  , t.has_trans_in_last_90d
  , t.has_trans_in_last_60d
  , t.has_trans_in_last_30d
  
  -- customer_status label
  , case
  		-- if first purchase within last 30 days
  		when t.min_cust_trans_dt >= (
									select
										today_date
									from
										pseudo_date
									) - interval '30 days'
				then 'new'
			
			-- first trans more than 30 days ago
			when   t.has_trans_in_last_60d = 1
				 and t.has_trans_in_last_30d = 0
				then 'dormant' 
			
			-- no puchase in the last 60d, consider churned from our site
			when	t.has_trans_in_last_60d = 0
				 and t.has_trans_in_last_30d = 0
				then 'churned'
			
			-- otherwise they are active
			else
				'active'
		end as customer_status
			
from
	trans_w_attributes t

where
	  	1=1
	and has_trans_in_last_90d = 1
)

--final query to find dormant accounts that made a purchase in the last 90 days
SELECT
	p.customer_id
	,c.first_name --Contains name so we can send an email in production
	,p.transaction_id
	,p.trans_dt::date --can get a date diff to find number of days from last purchase in a production setting
	,CAST('2022-10-31' as date) - p.trans_dt::date as "days_since_last_purchase" --hardcoded date for purposes of activity, but should be a subquery or subtracting from current_date in production
	,c.number_of_transactions
	,p.customer_status
FROM
	purchase_in_past_90_days as p
	JOIN
	customers as c on p.customer_id = c.customer_id
WHERE
		1=1
	and customer_status = 'churned' --use keywords so it's easier to filter for endusers
ORDER BY
	days_since_last_purchase DESC
	,number_of_transactions DESC --find customers with more transactions; makes an assumption they're more likly to buy again with the right deal
