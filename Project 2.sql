--I. Ad-hoc tasks:
-- Bài 1: 
select  FORMAT_DATE('%Y-%m', created_at) as year_month,
    count(distinct order_id) as total_order, 
    count(distinct user_id) as total_user
from bigquery-public-data.thelook_ecommerce.orders
where status='Shipped' and FORMAT_DATE('%Y-%m', created_at) between '2019-01' and '2022-04'
group by FORMAT_DATE('%Y-%m', created_at)
order by year_month
/*Nhìn chung, từ t1/2019 đến t4/2022 tổng số lượng đơn hàng và tổng số lượng người dùng đều có sự tăng trưởng 
đều đặn và liên tục theo thời gian. Điều này là một dấu hiệu tích cực cho sự ổn định và khả năng phát triển 
bền vững của TheLook trong tương lai */
-- Bài 2: 
select FORMAT_DATE('%Y-%m', a.created_at) as year_month,
    count(distinct a.user_id) as distinct_user,
    round(sum(b.sale_price)/count(a.order_id),2) as AOV
from bigquery-public-data.thelook_ecommerce.orders as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
where FORMAT_DATE('%Y-%m',a.created_at) between '2019-01' and '2022-04'
group by year_month
order by year_month
/*Từ T1/2019 đến T4/2022, số lượng người dùng có sự tăng trưởng rõ rệt đạt mức 1543 người vào T4/2022, trong khi đó, giá trị 
đơn hàng trung bình giữ ở mức ổn định khoảng 60.*/
--Bài 3
with cte as(
    select  first_name, last_name, age, gender, 'yongest' as tag
    from bigquery-public-data.thelook_ecommerce.users
    where age in (select min(age) from  bigquery-public-data.thelook_ecommerce.users group by gender)
    and extract(year from created_at) || '-' || extract(month from created_at) between '2019-01' and '2022-04'
    union  all
    select  first_name, last_name, age, gender, 'oldest' as tag
    from bigquery-public-data.thelook_ecommerce.users
    where age in (select max(age) from  bigquery-public-data.thelook_ecommerce.users group by gender)
    and extract(year from created_at) || '-' || extract(month from created_at) between '2019-01' and '2022-04')
select gender,age, tag, count(*)  
from cte
group by gender,age, tag
/* Cả 2 giới tính nam và nữ đều có cùng mức tuổi trẻ nhất là 12 và lớn nhất là 70 tuổi. 
    Nhóm giới tính nữ, 70 tuổi có số lượng 423 người thấp hơn so với cả 3 nhóm còn lại với số lượng xấp xỉ khoảng 435 người
    */
-- Bài 4
with cte as(
    select *, 
    dense_rank() over(partition by year_month order by profit desc) as rank_profit
    from 
        (select 
        extract(year from a.created_at) || '-' || extract(month from a.created_at) as year_month,
        a.product_id, b.name,
        round(sum(a.sale_price),2) as revenue, round(sum(b.cost),2) as cost, round(sum(a.sale_price-b.cost),2) as profit,
        from bigquery-public-data.thelook_ecommerce.order_items as a
        join bigquery-public-data.thelook_ecommerce.products as b on a.id=b.id
        group by a.product_id, b.name, extract(year from a.created_at) || '-' || extract(month from a.created_at)))
select * from cte
where rank_profit <= 5
order by year_month

-- Bài 5
select date(a.created_at) as day, 
  b.category, 
  round(sum(a.sale_price),2) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b on a.id=b.id
where date(a.created_at) between '2022-01-15' and '2022-04-15'
group by date(a.created_at), b.category
order by day, b.category

--II. 
--Bài 1
create view vw_ecommerce_analyst as(
with cte as(
        select 
        format_date('%m', a.created_at) as month,
        format_date('%Y', a.created_at) as year,
        c.category as Product_category,
        round(sum(b.sale_price),2) as TPV,
        count(distinct b.order_id) as TPO,
        round(sum(c.cost),2) as total_cost,
        round(sum(b.sale_price)-sum(c.cost),2) as total_profit,
        round((sum(b.sale_price)-sum(c.cost))/sum(c.cost),2) as Profit_to_cost_ratio
        from bigquery-public-data.thelook_ecommerce.orders as a
        join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
        join bigquery-public-data.thelook_ecommerce.products as c on b.id=c.id
        group by year, month, Product_category
        order by year, month, Product_category)
select month, year, product_category, TPV, TPO,
round((TPV-LAG(TPV) over(partition by Product_category order by year, month))*100/LAG(TPV) over(partition by Product_category order by year, month),2)||' %'as Revenue_growth,
round((TPO-LAG(TPO) over(partition by Product_category order by year, month))*100/LAG(TPO) over(partition by Product_category order by year, month),2)||' %'as Order_growth,
total_cost, total_profit, Profit_to_cost_ratio
from cte)

-- Bài 2
with cte as(
    select 
    format_date('%m', a.created_at) as month,
    format_date('%Y', a.created_at) as year,
    c.category as Product_category,
    round(sum(b.sale_price),2) as TPV,
    count(distinct b.order_id) as TPO,
    round(sum(c.cost),2) as total_cost,
    round(sum(b.sale_price)-sum(c.cost),2) as total_profit,
    round((sum(b.sale_price)-sum(c.cost))/sum(c.cost),2) as Profit_to_cost_ratio
    from bigquery-public-data.thelook_ecommerce.orders as a
    join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
    join bigquery-public-data.thelook_ecommerce.products as c on b.id=c.id
    group by year, month, Product_category
    order by year, month, Product_category)
, dataset as(
    select month, year, product_category, TPV, TPO,
    round((TPV-LAG(TPV) over(partition by Product_category order by year, month))*100/LAG(TPV) over(partition by Product_category order by year, month),2)||' %'as Revenue_growth,
    round((TPO-LAG(TPO) over(partition by Product_category order by year, month))*100/LAG(TPO) over(partition by Product_category order by year, month),2)||' %'as Order_growth,
    total_cost, total_profit, Profit_to_cost_ratio
    from cte)
,cohort as(
    select user_id, revenue, format_date('%Y-%m',first_month_year) as cohort_date, 
    (extract(year from created_at)-extract(year from first_month_year))*12+
    extract(month from created_at)-extract(month from first_month_year)+1 as index, 
    from(select user_id, round(sale_price,2) as revenue, created_at,
    min(created_at) over(partition by user_id order by created_at) as first_month_year
    from bigquery-public-data.thelook_ecommerce.order_items))
, cohort_data as(
    select cohort_date, index, 
    count(user_id) as count_user, round(sum(revenue),2) as revenue
    from cohort
    group by cohort_date, index)
--customer_cohort
,customer_cohort as(
    select cohort_date,
    sum(case when index=1 then count_user else 0 end) as t1,
    sum(case when index=2 then count_user else 0 end) as t2,
    sum(case when index=3 then count_user else 0 end) as t3,
    sum(case when index=4 then count_user else 0 end) as t4
    from cohort_data
    group by cohort_date
    order by cohort_date)
--retention cohort
select cohort_date,
t1/t1*100 || '%' as t1,
round(t2/t1*100,2) || '%' as t2, 
round(t3/t1*100,2) || '%' as t3, 
round(t4/t1*100,2) || '%' as t4
from customer_cohort

--Visualize trên excel: 
https://docs.google.com/spreadsheets/d/10htEoTLCKbegX-ycF0nehyTkaNlQzVoE/edit?usp=sharing&ouid=101215355215697439234&rtpof=true&sd=true

/*
*/
