--1)
select productline, year_id, dealsize, 
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
group by productline, year_id, dealsize
order by productline, year_id

--2)
with cte as(
select *,
rank() over(partition by year_id order by revenue desc) as r
from 
(select month_id, year_id,
sum(sales) as revenue,
count(distinct ordernumber) as order_number
from public.sales_dataset_rfm_prj_clean
group by month_id, year_id) as a)
select month_id, year_id, revenue, order_number
from cte
where r=1

--3)
with cte as(
select year_id, productline,
sum(sales) as revenue,
count(*) as order_number, 
rank() over(partition by year_id order by sum(sales) desc) as rank
from
(select productline, month_id,year_id, sales, ordernumber
from public.sales_dataset_rfm_prj_clean
where month_id=11) as a
group by productline, year_id)
select year_id, productline, revenue, order_number
from cte
where rank=1

--4)
with cte as(
select year_id, productline,
sum(sales) as revenue,
rank() over(partition by year_id order by sum(sales) desc) as rank
from
(select year_id, productline, sales
from public.sales_dataset_rfm_prj_clean
where country='UK') as a
group by year_id, productline)
select year_id, productline, revenue
from cte
where rank=1
order by revenue

--5)
with r_f_m as(
select customername,
current_date-max(orderdate) as R,
count(distinct ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj_clean
group by customername)
,rfm_score as(
select customername, 
ntile(5) over(order by R desc) as r_score,
ntile(5) over(order by F desc) as f_score,
ntile(5) over(order by M desc) as m_score
from r_f_m)
,rfm as(
select customername,
cast(r_score as varchar)|| cast(f_score as varchar)|| cast(m_score as varchar) as rfm_score
from rfm_score)
select a.customername, b.segment
from rfm as a
join public.segment_score as b on a.rfm_score=b.scores
where b.segment='Champions'
