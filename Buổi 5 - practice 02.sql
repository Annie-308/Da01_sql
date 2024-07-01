-- EX 01
Select distinct city from station
where id%2=0
-- EX 02
Select count(city) - count(distinct city) from station
-- EX 04
SELECT round(cast(sum(order_occurrences*item_count)/sum(order_occurrences)
as decimal),1)
from items_per_order
-- EX 05
SELECT candidate_id from candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill)=3;
-- EX 06
SELECT user_id,
date(max(post_date)) - date(min(post_date)) as days_between
from posts
where post_date between '01-01-2021' and '01-01-2022'
group by user_id
having date(max(post_date)) - date(min(post_date)) > 0
-- EX 07
SELECT card_name,
max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name 
order by max(issued_amount)-min(issued_amount) DESC
-- EX 08
SELECT manufacturer,
count(drug) as drug_count, 
sum(cogs-total_sales) as total_loss
from pharmacy_sales
where total_sales<cogs
group by manufacturer
order by total_loss DESC
-- EX 09
select id, movie, description, rating
from cinema
where description <> 'boring'
having id%2 <> 0
order by rating desc
-- EX 10
select teacher_id, 
count(distinct subject_id ) as cnt
from Teacher
group by teacher_id
-- EX 11
select user_id,
count(follower_id) as followers_count
from Followers
group by user_id
order by user_id
-- EX 12
select class
from Courses
group by class
having count(student) >= 5
