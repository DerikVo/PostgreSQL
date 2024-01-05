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
;
