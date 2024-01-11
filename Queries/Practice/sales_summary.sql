/*
This query was created by Brandon southern and commented out by Derik Vo to understand the logic
*/

----------------------------------------------------------
--CTE to get total sales aggregated by transaction ID
with transaction_totals as (
	select
		  ti.transaction_id
		, sum(p.price) as total_sales
	from
		transaction_items ti
		join products p on p.product_id = ti.product_id
	group by
		ti.transaction_id
)
--Gets the transaction  date and id and joins it with transactions_totals to get total_sales and quartiles
, trans_sales as (
	select
		t.trans_dt
	  , t.transaction_id
	  , ti.total_sales
	  , ntile(4) over(order by ti.total_sales asc) as quartile
	from
		transactions t
		join transaction_totals ti on t.transaction_id = ti.transaction_id
) 
--Groups the total_sales into quartiles
, quartile_summary as (
	select
		s.quartile
	  , min(s.total_sales) as total_sales
	from
		trans_sales s
	group by
		s.quartile
	order by
		s.quartile
)

--This comment was from Brandon Souther
/*
	create a summary cte of our avg, min, and max.
		we want to do this here because were doing to do a cross
		join next to get a nice output and we need a very efficient 
		cross-join
*/


--gets the avg, min, and max values
, total_sales_summary as (
	select
	  avg(s.total_sales) as avg_total_sales
    , max(s.total_sales) as max_total_sales
	, min(s.total_sales) as min_total_sales
	from
		trans_sales s
)

-- testing the Ctes
-- select
-- *
-- from
-- total_sales_summary



--Combines the whole report into one output; Personally added a round function, replaced the comma with cross join, and added the 4th quartile
select
	round(s.avg_total_sales, 2) as avg_total_sales
  , s.max_total_sales
  , s.min_total_sales
  , max(case when q.quartile = 1 then q.total_sales else 0 end) as quartile_1_total_sales
  , max(case when q.quartile = 2 then q.total_sales else 0 end) as median_total_sales
  , max(case when q.quartile = 3 then q.total_sales else 0 end) as quartile_3_total_sales
  ,max(case when q.quartile = 4 then q.total_sales else 0 end) as quartile_4_total_sales
  
from
	total_sales_summary s
	CROSS JOIN quartile_summary q
group by
	s.avg_total_sales
	,s.max_total_sales
	,s.min_total_sales

