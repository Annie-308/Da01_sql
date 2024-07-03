-- EX 01
select name
from STUDENTS
where Marks > 75
order by  right(name,3), id
-- EX 02
select user_id,
Concat(Upper(left(name,1)),lower(right(name,length(name)-1))) as name
from Users
order by user_id
-- EX 03
select manufacturer,
'$' || round(sum(total_sales)/1000000,0) ||' '||'million' as sales_mil
from pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer
-- EX 04
SELECT extract(month from submit_date) as mth, product_id, 
round(avg(stars),2) as avg_stars
from reviews
group by product_id, extract(month from submit_date)
order by mth, product_id
-- EX 05
SELECT sender_id,
count(*) as message_count
FROM messages
where sent_date between '08/01/2022' and '09/01/2022'
group by sender_id
order by message_count Desc
limit 2
-- EX 06
select tweet_id
from Tweets
where length(content)>15
-- EX 07
select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date between '2019-06-27' and '2019-07-27'
group by activity_date
-- EX 08
select count(*) as number_employees
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022
-- EX 09
select position('a' in first_name)
from worker
where first_name='Amitah'
-- EX 10
select
substring (title,length(winery)+2,4) as year
from winemag_p2
where country='Macedonia'
