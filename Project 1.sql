-- Bài 1
alter table sales_dataset_rfm_prj
alter column orderlinenumber type varchar
	
alter table sales_dataset_rfm_prj
alter column quantityordered type numeric USING (trim(quantityordered)::numeric)

alter table sales_dataset_rfm_prj
alter column priceeach type numeric USING (trim(priceeach)::numeric)

alter table sales_dataset_rfm_prj
alter column sales type numeric USING (trim(sales)::numeric)

alter table sales_dataset_rfm_prj
alter column orderdate type date USING (trim(orderdate)::date)

alter table sales_dataset_rfm_prj
alter column msrp type numeric USING (trim(msrp)::numeric)
-- Bài 2
select * from public.sales_dataset_rfm_prj
where ordernumber is null 
	or QUANTITYORDERED is null 
	or PRICEEACH is null 
	or ORDERLINENUMBER is null 
	or SALES is null 
	or ORDERDATE is null 

-- Bài 3:
alter table sales_dataset_rfm_prj 
add column CONTACTLASTNAME varchar(50)

alter table sales_dataset_rfm_prj 
add column CONTACTFIRSTNAME varchar(50)

update sales_dataset_rfm_prj
set contactfirstname = upper(substring(left(contactfullname, position('-' in contactfullname)-1) from 1 for 1)) ||
	right(left(contactfullname, position('-' in contactfullname)-1),length(left(contactfullname, position('-' in contactfullname)-1))-1)
  
update sales_dataset_rfm_prj
set CONTACTLASTNAME = upper(substring(right(contactfullname, length(contactfullname)-position('-' in contactfullname))from 1 for 1)) ||
right(right(contactfullname, length(contactfullname)-position('-' in contactfullname)),length(right(contactfullname, length(contactfullname)-position('-' in contactfullname)))-1)

-- Bài 4
alter table sales_dataset_rfm_prj
add column qtr_id

alter table sales_dataset_rfm_prj
add column month_id

alter table sales_dataset_rfm_prj
add column year_id

update sales_dataset_rfm_prj
set qtr_id=extract(quarter from orderdate)

update sales_dataset_rfm_prj
set month_id = extract(month from orderdate)

update sales_dataset_rfm_prj
set year_id = extract(year from orderdate)

--Bài 5
with cte1 as(
	with cte as(
		select Q1-1.5*IQR AS min_value, Q3+1.5*IQR AS max_value
		from(select 
		percentile_cont(0.25) within group (order by quantityordered) as Q1,
		percentile_cont(0.75) within group (order by quantityordered) as Q3,
		percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered) as IQR
		from public.sales_dataset_rfm_prj) as a)
	select * from sales_dataset_rfm_prj
	where quantityordered < (select min_value from cte) or quantityordered > (select max_value from cte))
delete from sales_dataset_rfm_prj
where quantityordered in (select quantityordered from cte1)

-- Bài 6
Create table SALES_DATASET_RFM_PRJ_CLEAN as
(select * from public.sales_dataset_rfm_prj)
