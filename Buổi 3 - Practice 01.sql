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
Select name from customer
where not (referee_id = 2) or referee_id is null

-- EX 11
select name, population, area from world
where area >=3000000 or population >=25000000

-- EX 12
select distinct author_id as id from views
where author_id = viewer_id
order by id asc

-- EX 13
SELECT part,assembly_step from parts_assembly
where finish_date is null

-- EX 14
select * from lyft_drivers
where yearly_salary <=30000 or yearly_salary >=70000
-- EX 15
select * from uber_advertising
where money_spent >100000 and year = 2019
