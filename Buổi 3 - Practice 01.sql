--EX 01:
Select name from city
where countrycode = 'USA' and (population > 120000)

-- EX 02:
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'

-- EX 03
SELECT City, State from STATION

-- EX 04
select distinct city from station
where city like 'i%' or city like 'e%' or city like 'a%' or city like 'o%' or city like 'u%'

-- EX 05
Select distinct city from station 
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u' 

-- EX 06
select distinct city from station
where not (city like 'i%' or city like 'e%' or city like 'a%' or city like 'o%' or city like 'u%')

-- EX 07
select name from employee
order by name

-- EX 08
select name from employee
where salary >2000 and months <10
order by employee_id 

-- EX 09
select product_id from products
where low_fats = 'Y' and recyclable = 'Y'

-- EX 10
-- EX 11
-- EX 12
-- EX 13
-- EX 14
-- EX 15
