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

-- EX 05
with twt_new_6 as (
select distinct user_id, extract(month from event_date) as month
from user_actions
where extract(month from event_date)='6'),
twt_new_7 as (
select distinct user_id, extract(month from event_date) as month
from user_actions
where extract(month from event_date)='7')
select c.month, count(*) as monthly_active_users
from twt_new_6 as b 
join twt_new_7 as c on b.user_id=c.user_id
group by c.month

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
select employee_id from Employees
where manager_id not in (select employee_id from Employees)

-- EX 10
with twt_job_count as(
select company_id, title, count(*) as job_count
from job_listings
group by company_id, title)
select count(*) from twt_job_count
where job_count > 1

-- EX 11
with twt_name as(
select b.name as results
from MovieRating as a
join Users as b on a.user_id=b.user_id
having max(rating)),
twt_movie as(
select c.title
from MovieRating as a
join Movies as c
on a.movie_id=c.movie_id
where substring(created_at from 1 for 7)='2020-02'
group by a.movie_id
order by avg(a.rating) desc, c.title
limit 1)
select results from twt_name
union 
select title from twt_movie

-- EX 12
with new as (
select requester_id as id, count(accepter_id) as num from RequestAccepted where requester_id='1'
union 
select accepter_id as id, count(requester_id) as num from RequestAccepted where accepter_id='1'
union 
select requester_id as id, count(accepter_id) as num from RequestAccepted where requester_id='2'
union 
select accepter_id as id, count(requester_id) as num from RequestAccepted where accepter_id='2'
union 
select requester_id as id, count(accepter_id) as num from RequestAccepted where requester_id='3'
union 
select accepter_id as id, count(requester_id) as num from RequestAccepted where accepter_id='3')
select id, sum(num) as num
from new
group by id
order by sum(num)  desc
limit 1
