-- EX 01
SELECT
sum(CASE
when device_type = 'laptop' then 1 else 0
END) as laptop_views,
sum(CASE
when device_type in ('phone', 'tablet') then 1 else 0
END) as mobile_views
FROM viewership
-- EX 02
select x,y,z,
case when x+y>z then 'Yes' else 'No'
end as triangle
from Triangle
-- EX 03
select 
round(sum(CASE 
WHEN call_category is null or call_category='n/a' then 1 else 0 
END)*100/count(*),1) as uncategorised_call_pct
from callers
-- EX 04
Select name from customer
where not (referee_id = 2) or referee_id is null
-- EX 05
select survived,
sum(case
when pclass=1 then 1 else 0
end) as first_class,
sum(case
when pclass=2 then 1 else 0
end) as second_classs,
sum(case
when pclass=3 then 1 else 0
end) as third_class
from titanic
group by survived
