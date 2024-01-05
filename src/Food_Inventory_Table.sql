/*
Uses the Foods.csv from the Food_Inventory_Table folder
*/

create table foods
(
food_id bigint,
item_name character varying(255),
storage_type character varying(255),
package_size integer,
package_size_uom character varying(255),
brand_name character varying(255),
package_price numeric(10,2),
price_last_updated_ts timestamp without time zone
)
;

/*
Uses the Foods_inventories.csv from the Food_Inventory_Table folder
*/ 

CREATE TABLE food_inventories
(
food_inventory_id bigint,
food_item_id bigint,
quantity integer,
inventory_dt date
)

;

/*
Uses the Drinks.csv from the Food_Inventory_Table folder
*/

create table drinks
(
drink_id bigint,
item_name character varying(255),
storage_type character varying(255),
package_size integer,
package_size_uom character varying(255),
brand_name character varying(255),
package_price numeric(10,2),
price_last_updated_ts timestamp without time zone
)
;
