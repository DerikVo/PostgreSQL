/*
This table is for the 'customers' csv fle
*/

CREATE TABLE customers
(
	customer_id bigint
	, customer_name varchar(255)
	, birth_year integer(4)
	, birth_month integer(2)
	, gender varchar(255)
	, address varchar(255)
	, address_2 varchar(255)
	, city varchar(255)
	, state_abv character(2)
	, zip_code varchar(255)
	, per_capita_income_by_zip_code numeric(14,2)
	, yearly_income numeric(14,2)
)
;

/*
This table is for the 'states' csv fle
*/

create table states(
	state_id bigint
	,state_abv varchar(2)
)
;
/*
This table is for the 'employees' csv fle
*/
CREATE TABLE employees
(
  	employee_id bigint
	, first_name varchar(255)
	, manager_id bigint
	, address varchar(255)
	, city varchar(255)
	, state_abv varchar(2)
	, zip_code varchar(20)
	, phone_number varchar(20) 
)
;

/*
This table is for the "Transactions" csv file
*/
create table transactions
(
transaction_date date,
customer_id bigint,
transaction_id bigint,
quantity integer,
sku character varying(255),
unit_price numeric(10,2)
)
;
