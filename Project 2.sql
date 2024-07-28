-- Bài 1: order by chưa đúng
select extract(year from created_at) || '-' || extract(month from created_at) as year_month,
    count(distinct order_id) as total_order, 
    count(distinct user_id) as total_user
from bigquery-public-data.thelook_ecommerce.orders
where status='Shipped' and extract(year from created_at) || '-' || extract(month from created_at) between '2019-01' and '2022-04'
group by extract(year from created_at) || '-' || extract(month from created_at)
order by year_month

-- Bài 2: order by chưa đúng
select extract(year from a.created_at) || '-' || extract(month from a.created_at) as year_month,
    count(distinct a.user_id) as distinct_user,
    round(sum(b.sale_price)/count(a.order_id),2) as AOV
from bigquery-public-data.thelook_ecommerce.orders as a join bigquery-public-data.thelook_ecommerce.order_items as b on a.order_id=b.order_id
where extract(year from a.created_at) || '-' || extract(month from a.created_at) between '2019-01' and '2022-04'
group by year_month
order by year_month

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
    Nhóm giới tính nữ, 70 tuổi có số lượng 423 người thấp hơn so với cả 3 nhóm còn lại với số lượng xấp xỉ khoảng 435 
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
