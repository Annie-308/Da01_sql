-- EX 01
with cte1 as (
  select extract( year from transaction_date) as year, 
  product_id, sum(spend) as curr_year_spend
  from user_transactions
  group by extract( year from transaction_date), product_id
)
select year, product_id, curr_year_spend,
lag(curr_year_spend) over(partition by product_id order by year) as prev_year_spend,
round(curr_year_spend*100.00/lag(curr_year_spend) over(partition by product_id order by year)-100,2) as yoy_rate
from cte1
-- EX 02
with cte1 
as(
SELECT card_name, issued_amount,
row_number() over (partition by card_name order by issued_amount) as stt
FROM monthly_cards_issued
)
select card_name, issued_amount
from cte1
where stt='1'
order by issued_amount desc

-- EX 03
with cte1
as(
SELECT *,
row_number() over(partition by user_id order by transaction_date)
FROM transactions
)
select user_id, spend, transaction_date
from cte1 
where row_number='3'

-- EX 04
with cte 
as(
select user_id,transaction_date,
rank() over(partition by user_id order by transaction_date desc) 
from user_transactions
)
select transaction_date, user_id,
count(*) as purchase_count
from cte
where rank='1'
group by user_id, transaction_date
order by transaction_date

-- EX 05: chưa được
SELECT user_id, tweet_date,
round(avg(tweet_count) over (partition by user_id order by tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2)
FROM tweets

-- EX 06

-- EX 07
-- EX 08
