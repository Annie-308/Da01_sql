-- EX 01
 with cte as (
        select *, rank() over(partition by customer_id order by order_date) as first_order
        from Delivery), 
    cte1 as (
        select * from cte 
        where first_order=1)
select round(sum(case 
when customer_pref_delivery_date=order_date then 1 else 0
end)*100/count(*),2) as immediate_percentage
from cte1

-- EX 02
with cte as (
    select *, lag(event_date) over(partition by player_id) as previous_date,
    from Activity)
select round((select count(distinct player_id)
from cte
    where extract(year from event_date)=extract(year from previous_date)
    and extract(month from event_date)=extract(month from previous_date)
    and extract(day from event_date)=extract(day from previous_date)+1) / count(distinct player_id),2) as fraction
from cte

-- EX 06
with cte1 as(
    with cte as(
        select b.name as Department, a.name as Employee , a.salary as Salary
        from Employee as a
        join Department as b
        on a.departmentId=b.id)
        select *, dense_rank() over(partition by Department order by Salary desc ) as rank_salary
from cte)
select Department, Employee, Salary from cte1
where  rank_salary <=3
