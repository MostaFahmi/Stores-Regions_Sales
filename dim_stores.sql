------------------------------------------------------
--------------------dim_store--------------------------
-- TABLE CREATION


-- Drop dim_store and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_store'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_store
;



-- Drop and Create dim_store

if exists (select * from sys.objects
			where name = 'dim_store'
			and type = 'U')
Drop Table dim_store

go 
Create Table dim_store
(
	store_key int not null primary key identity(1,1),--surrogate key
	store_id int not null, --alternate key - business key
	store_name nvarchar(150) not null,
	region nvarchar(50),

	-- metadata
	source_system_code tinyint not null,

	-- SCD
	start_date datetime not null default(getdate()),
	end_date datetime,
	Is_Current tinyint not null default(1),

)





-- insert the UNKOWN record for the fact_sales later

set identity_insert dim_store on

insert into dim_store(store_key,store_id,store_name,region,source_system_code,start_date,end_date,Is_Current)
values(0,0,'UNKOWN','UNKOWN',0,'1900-01-01',null,1)

set identity_insert dim_store off






-- re-define dim_store and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_store foreign key (store_key) references dim_store(store_key)





-- create mostly used index for searching
--- store_id index


if exists (select * from sys.indexes
			where name = 'dim_store_store_id'
			and object_id = object_id('dim_store'))
drop index dim_store.dim_store_store_id;

create index dim_store_store_id 
	on dim_store(store_id);


--- store_name index


if exists (select * from sys.indexes
			where name = 'dim_store_store_name'
			and object_id = object_id('dim_store'))
drop index dim_store.dim_store_store_name;

create index dim_store_store_name
	on dim_store(store_name);





