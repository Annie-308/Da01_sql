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
