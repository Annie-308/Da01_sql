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
WITH cte as(
select 
credit_card_id, lag(credit_card_id) over(partition by merchant_id) as previous_credit_card_id,
amount, lag(amount) over(partition by merchant_id) as previous_amount,
transaction_timestamp, lag(transaction_timestamp)over(partition by merchant_id) as previous_transaction_timestamp
from transactions
)
select count(*) as payment_count
from cte 
where credit_card_id=previous_credit_card_id
and amount=previous_amount 
and (extract(hour from transaction_timestamp - previous_transaction_timestamp)*60
+ extract(minute from transaction_timestamp - previous_transaction_timestamp)<=10
)

 
-- EX 07
with cte1 
as(
  select category, product, extract(year from transaction_date) as year,
  sum(spend) as total_spend,
  rank() over(partition by category order by sum(spend) desc)
  from product_spend
  group by category, product, extract(year from transaction_date)
  order by category
)
select category, product, total_spend
from cte1
where rank<=2 and year='2022'

-- EX 08
with cte
as(
    SELECT c.artist_name,
     dense_rank() over(order by count(*) desc) as artist_rank
    FROM global_song_rank as a  
    join songs as b on a.song_id=b.song_id
    join artists as c on b.artist_id=c.artist_id
    where a.rank <= 10
    group by artist_name
  )
select artist_name, artist_rank
from cte  
where artist_rank<=5
