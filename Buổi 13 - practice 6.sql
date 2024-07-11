--EX 01
with twt_job_count as(
select company_id, title, count(*) as job_count
from job_listings
group by company_id, title)
select count(*) from twt_job_count
where job_count > 1

-- EX 02
with twt_total_spend_appliance as(
SELECT category, product, sum(spend) as total_spend
FROM product_spend
where category='appliance' and extract(year from transaction_date)='2022'
group by category, product
order by sum(spend) desc
limit 2),
twt_total_spend_electronics as(
SELECT category, product, sum(spend) as total_spend
FROM product_spend
where category='electronics' and extract(year from transaction_date)='2022'
group by category, product
order by sum(spend) desc
limit 2)
select *
from  twt_total_spend_appliance 
union 
select *
from twt_total_spend_electronics

-- EX 03
with twt_call_count as (
SELECT count(*) as call_count
from callers
group by policy_holder_id)
select count(*) as policy_holder_count
from twt_call_count
where call_count >=3

-- EX 04
SELECT a.page_id
from pages as a  
full join page_likes as b  
on a.page_id=b.page_id
where liked_date is null
order by page_id

-- EX 05: chưa được


-- EX 06
with twt_total as(
select substring(trans_date from 1 for 7) as month, country, count(id) as trans_count, sum(amount) as trans_total_amount
from Transactions
group by month, country),
twt_approved as (
select substring(trans_date from 1 for 7) as month, country, count(id) as approved_count, sum(amount) as approved_total_amount
from Transactions 
where state='approved'
group by month, country)
select a.month, a.country, a.trans_count, b.approved_count, a.trans_total_amount, b.approved_total_amount
from twt_total as a
join twt_approved as b
on a.month=b.month and a.country=b.country

-- EX 07
select product_id, min(year) as first_year, quantity, price
from Sales
group by product_id

-- EX 08
select customer_id 
from Customer
group by customer_id
having count(distinct product_key) >= (select count(distinct product_key) from Product)

-- EX 09


-- EX 10
-- EX 11
-- EX 12
