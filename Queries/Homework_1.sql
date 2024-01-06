--Can use select * to select all columns, but implicitly naming columns is ideal
SELECT
	count(*)
FROM
	foods
;

--This porton identifies null brand names

SELECT
	price_last_updated_ts
	,food_id
	,Item_name
	,storage_type
	,package_size
	,package_size_uom as package_size_unit_of_measurement
	,brand_name
	,package_price
FROM
	foods
WHERE
	brand_name is null
	or
	brand_name = ''
	
-- this query is to count brand names; can use group by, but I wanted to practice window functions

SELECT
    distinct(brand_name)
    ,COUNT(*) OVER (partition by brand_name) as counts
FROM
    foods
ORDER BY
    counts DESC;

/*
One benefit of implicitly naming the columns is you can control the orderin this case timestamp goes first

In this assigned we were task with finding private labels brands, 
the instructor simply used a where clause and a ilike statement.
I wanted to incorporate CTE and case statements to create an 
implicit label for private (store brand) and public (name brand) in case the stakeholder needed
to compare the store brand to the name brand.


*/
WITH foods_with_label as (
SELECT
	price_last_updated_ts
	,food_id
	,Item_name
	,storage_type
	,package_size
	,package_size_uom as package_size_unit_of_measurement
	,brand_name
	,case when 
		brand_name ilike ('%private label%') Then 'Private'
	 	Else 'Public'
	end as "label"
	,package_price
FROM
	Foods
)
-- uses cte to find Private labels
SELECT
	*
FROM
	foods_with_label
WHERE
	label = 'Private'
;

--This portion identifies canned items and creates a new column

SELECT
	price_last_updated_ts
	,food_id
	,Item_name
	,storage_type
	,package_size
	,package_size_uom as package_size_unit_of_measurement
	,brand_name
	,case when 
		item_name ilike ('%can%') Then 'Yes'
	 		Else 'No'
		end as "item_is_canned"
	,package_price
FROM
	Foods
	
--Calculates the proportion of H-E-B branded foods

SELECT
	((
		SELECT 
			count(*)
		FROM
			foods
		WHERE
			brand_name ilike '%H-e-b%'
		)::float / count(*)::float) as "percentage"
FROM
	Foods
;

--Find the percentage of a brand; again practicing window functions
SELECT
	distinct(brand_name)
		,ROUND((
			((round(count(*) over (partition by brand_name)::DECIMAL))
			/(round(count(*) over ()::DECIMAL)))*100 
		)::DECIMAL, 2)as "percent make up"

FROM
	foods
