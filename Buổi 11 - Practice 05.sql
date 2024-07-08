-- EX 01
SELECT a.continent, floor(avg(b.population))
FROM COUNTRY AS a
INNER JOIN CITY as b
on a.code=b.countrycode
group by  a.continent
  
-- EX 02
select 
round(cast(count(b.email_id) as decimal)/count(distinct a.email_id),2) as activation_rate
from emails as a  
left join texts as b  
on a.email_id=b.email_id
and b.signup_action = 'Confirmed'
  
-- EX 03
select b.age_bucket,
round(sum(a.time_spent) FILTER (WHERE a.activity_type = 'send')*100.00/sum(a.time_spent),2) as send_perc,
round(sum(a.time_spent) FILTER (WHERE a.activity_type = 'open')*100.00/sum(a.time_spent),2) as open_perc
from activities as a  
inner join age_breakdown as b  
on a.user_id=b.user_id
where a.activity_type in ('open','send')
group by b.age_bucket
  
-- EX 04
SELECT customer_id
FROM customer_contracts as a
left join products as b  
on a.product_id=b.product_id
group by customer_id
having count(DISTINCT product_category) = 3
  
-- EX 05
select m.employee_id, m.name, count(e.employee_id) as reports_count,
round(avg(e.age),0) as average_age
from Employees as e
join Employees as m
on e.reports_to=m.employee_id
group by employee_id
  
-- EX 06
select P.product_name, SUM(O.unit) as unit
from Products as P
join Orders as O
on P.product_id=O.product_id
where O.order_date between '2020-02-01' and '2020-02-28'
group by O.product_id
having SUM(O.unit)>=100 
  
-- EX 07
SELECT a.page_id
from pages as a  
full join page_likes as b  
on a.page_id=b.page_id
where liked_date is null
order by page_id

-- MID COURSE TEST
-- CÂU 1
select distinct replacement_cost
from film
order by replacement_cost
limit 1

-- CÂU 2
select 
(case when replacement_cost between '9.99' and '19.99' then 'Low' end,
case when replacement_cost between '20.00' and '24.99' then 'Mid'end,
case when replacement_cost between '25.00' and '29.99' then 'High' end) as phan_loai,
count(film_id)
from film
group by phan_loai

-- CÂU 3
select a.title, a.length, c.name
from public.film as a
join public.film_category as b on a.film_id=b.film_id
join public.category as c on b.category_id=c.category_id
where c.name in ('Drama', 'Sports')
order by length desc
limit 1

-- CÂU 4
select b.name,
count(film_id)
from public.film_category as a
join public.category as b
on a.category_id=b.category_id
group by b.name
order by count(film_id) desc
limit 1

-- CÂU 5
select b.first_name, b.last_name, count(film_id)
from public.film_actor as a
join public.actor as b
on a.actor_id=b.actor_id
group by b.first_name, b.last_name
order by count(film_id) desc
limit 1

-- CÂU 6
select 
count(a.address) filter (where b.customer_id is null)
from public.address as a
left join public.customer as b
on a.address_id=b.address_id

-- CÂU 7
select d.city, sum(a.amount)
from payment as a
join customer as b on a.customer_id=b.customer_id
join public.address as c on b.address_id=c.address_id
join public.city as d on c.city_id=d.city_id
group by d.city
order by sum(a.amount) desc
limit 1

-- CÂU 8
select concat(d.city,', ',e.country) as city_of_country, sum(a.amount)
from payment as a
join customer as b on a.customer_id=b.customer_id
join public.address as c on b.address_id=c.address_id
join public.city as d on c.city_id=d.city_id
join public.country as e on d.country_id=e.country_id
group by d.city, e.country
order by sum(a.amount) desc
limit 1
