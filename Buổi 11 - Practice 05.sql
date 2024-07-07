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

-- EX 04
SELECT customer_id
FROM customer_contracts as a
left join products as b  
on a.product_id=b.product_id
group by customer_id
having count(DISTINCT product_category) = 3
-- EX 05
-- EX 06
-- EX 07
