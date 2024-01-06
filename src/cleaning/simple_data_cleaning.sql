/*
This is for cleaning the foods database for homework 1
*/
--Simple excercise to clean data; first we find whats missing or wrong
SELECT
	*
FROM
	foods
;
--update storage type of null values
UPDATE foods
	set storage_type = 'dry'
WHERE
	storage_type is null
	and
	item_name ilike '%rice%'
;
--proper case so we have consistiency
UPDATE foods
	SET 
		storage_type = INITCAP(storage_type)
		,item_name = INITCAP(item_name)
		,brand_name = INITCAP(brand_name)
;

--Proper case

--Update null values for food storage, so it makes sense to the end user
UPDATE foods
	SET storage_type = 'Unknown'
		WHERE
			storage_type IS NULL

