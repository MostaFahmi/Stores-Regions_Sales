------------------------------------------------------
--------------------dim_reps--------------------------
-- TABLE CREATION


-- Drop dim_reps and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_reps'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_reps
;



-- Drop and Create dim_reps

if exists (select * from sys.objects
			where name = 'dim_reps'
			and type = 'U')
Drop Table dim_reps

go 
Create Table dim_reps
(
	reps_key int not null primary key identity(1,1),--surrogate key
	reps_id int not null, --alternate key - business key
	reps_name nvarchar(150) not null,

	-- metadata
	source_system_code tinyint not null,

	-- SCD
	start_date datetime not null default(getdate()),
	end_date datetime,
	Is_Current tinyint not null default(1),

)





-- insert the UNKOWN record for the fact_sales later

set identity_insert dim_reps on

insert into dim_reps(reps_key,reps_id,reps_name,source_system_code,start_date,end_date,Is_Current)
values(0,0,'UNKOWN',0,'1900-01-01',null,1)

set identity_insert dim_reps off






-- re-define dim_reps and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_reps foreign key (reps_key) references dim_reps(reps_key)






-- create mostly used index for searching
--- reps_id index


if exists (select * from sys.indexes
			where name = 'dim_reps_reps_id'
			and object_id = object_id('dim_reps'))
drop index dim_reps.dim_reps_reps_id;

create index dim_reps_reps_id 
	on dim_reps(reps_id);


--- reps_name index


if exists (select * from sys.indexes
			where name = 'dim_reps_reps_name'
			and object_id = object_id('dim_reps'))
drop index dim_reps.dim_reps_reps_name;

create index dim_reps_reps_name
	on dim_reps(reps_name);





