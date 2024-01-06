/* 
This query is for identifying a count of first and last name. This will be primirly used to teach students about window functions

The data used here comes from the 'customers' csv 
*/

SELECT
	left(customer_name, strpos(customer_name, ' ')) as first_name --Gets a substring of a customers first name
	,right(customer_name, strpos(customer_name, ' ')*-1) as last_name --Gets a substring of the customers last name
	,customer_name -- gets the customers full name for context and validity 
	,count(*) OVER (Partition by left(customer_name, strpos(customer_name, ' '))) as first_name_count --window function to get a count of first name
	,count(*) OVER (Partition by right(customer_name, strpos(customer_name, ' ')*-1)) as last_name_count -- window function to get a count of last name
FROM
	customers
Order by
	last_name --order by last name so we can manually count as well; last names more common than first names in this dataset
	,first_name --After last name, output will then be ordered by first name; can manually count both names to verify output
