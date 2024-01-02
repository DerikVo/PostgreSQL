/*
CTE for our calculations, so we can use a where clause cleanly
*/
with transactions_cte as(
SELECT
    transaction_id
    ,transaction_date
    ,current_date
	
	/*
	The following portion is experimenting with date functions
	in postgresql which does not have a date_between function.
	*/
	,EXTRACT(YEAR FROM AGE(CURRENT_DATE, transaction_date)) * 12 +
		+EXTRACT(MONTH FROM AGE(CURRENT_DATE, transaction_date))

		-- This case statement is for calculating a full cycle'd month for more precision
		-CASE 
			WHEN EXTRACT(DAY FROM CURRENT_DATE) < EXTRACT(DAY FROM transaction_date) THEN 1
			ELSE 0
		END AS months_difference_case

	--comparison for case statement logic, we assume some month differences to be a year off
	,(EXTRACT(YEAR FROM AGE(CURRENT_DATE, transaction_date)) * 12)
    	+EXTRACT(MONTH FROM AGE(CURRENT_DATE, transaction_date)) AS months_difference_extract
FROM
    transactions
)

SELECT
	*
FROM
	transactions_cte
WHERE
	months_difference_case != months_difference_extract; --Find mismatches
/*
With this query we find the expect mismatch of the extract only clause
*/
