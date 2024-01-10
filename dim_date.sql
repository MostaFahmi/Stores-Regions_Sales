------------------------------------------------------
--------------------Dim_Date--------------------------
-- TABLE CREATION

-- Drop dim_date and fact_sales relationship

if exists (select * from sys.foreign_keys
			where name = 'fk_fact_sales_dim_date'
			and parent_object_id = object_id('fact_sales'))
alter table fact_sales drop constraint fk_fact_sales_dim_date
;

-- Drop and Create dim_date

if exists (select * from sys.objects
			where name = 'dim_date'
			and type = 'U')
Drop Table dim_date

go 
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,
    DateFull Date,
    Year INT,
    Quarter INT,
    Month INT,
    Day INT,
    DayOfWeek INT,
    DayName nvarchar(10),
    MonthName nvarchar(10)
);
go
Insert into Dim_Date
Values
(
	0,
	'1900-01-01',
	0,
	0,
	0,
	0,
	0,
	'Unknown',
	'Unknown')

-- TABLE POPULATION
go
DECLARE @StartDate DATE = '2000-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date (
        DateKey,
        DateFull,
        Year,
        Quarter,
        Month,
        Day,
        DayOfWeek,
        DayName,
        MonthName
    )
    VALUES (
        CONVERT (char(8),@StartDate,112),
        CONVERT(VARCHAR(10), @StartDate, 120),
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DAY(@StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATENAME(MONTH, @StartDate)
    )
	
	;

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

-- re-define dim_date and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_date foreign key (datekey) references dim_date(datekey)




-- re-define dim_date and fact_sales relationship


if exists (select * from sys.tables
			where name = 'fact_sales')
alter table fact_sales add constraint fk_fact_sales_dim_date foreign key (datekey) references dim_date(datekey)






-- create mostly used index for searching
--- date_id index


if exists (select * from sys.indexes
			where name = 'dim_date_Year'
			and object_id = object_id('dim_date'))
drop index dim_date.dim_date_Year;

create index dim_date_Year
	on dim_date(Year);