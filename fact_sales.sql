------------------------------------------------------
--------------------fact_sales--------------------------
-- TABLE CREATION


-- Drop and Create fact_sales

if exists (select * from sys.objects
			where name = 'fact_sales'
			and type = 'U')
Drop Table fact_sales

go 
Create Table fact_sales
(
	ID nvarchar(15) not null,
	order_number  int not null,
	store_key int not null,
	reps_key int not null,
	product_key int not null,
	quantity int,
	revenue money,
	ReturnedReason nvarchar(400),
	order_DateKey int not null,
	created_at datetime not null default(getdate())

	

	-- Defining The Relaionships
	constraint pk_fact_sales 
		primary key (ID,order_number,store_key,reps_key,product_key),

	constraint fk_fact_sales_dim_product 
		foreign key (product_key) references dim_product(product_key),

	constraint fk_fact_sales_dim_store
		foreign key (store_key) references dim_store(store_key),

	constraint fk_fact_sales_dim_customer 
		foreign key (reps_key) references dim_reps(reps_key),


	constraint fk_fact_sales_dim_date 
		foreign key (order_DateKey) references dim_date(DateKey)
)




-- create mostly used index for searching
--- order_DateKey index


if exists (select * from sys.indexes
			where name = 'fact_sales_order_DateKey'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_order_DateKey;

create index fact_sales_order_DateKey 
	on fact_sales(order_DateKey);



--- product_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_product_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_product_key;

create index fact_sales_product_key 
	on fact_sales(product_key);



--- reps_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_customer_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_reps_key;

create index fact_sales_reps_key 
	on fact_sales(reps_key);


--- store_key index


if exists (select * from sys.indexes
			where name = 'fact_sales_store_key'
			and object_id = object_id('fact_sales'))
drop index fact_sales.fact_sales_store_key;

create index fact_sales_store_key 
	on fact_sales(store_key);





