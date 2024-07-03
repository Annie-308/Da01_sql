-- EX 01
select name
from STUDENTS
where Marks > 75
order by  right(name,3), id
-- EX 02
select user_id,
Concat(Upper(left(name,1)),lower(right(name,length(name)-1))) as name
from Users
order by user_id
-- EX 03

-- EX 04
-- EX 05
-- EX 06
-- EX 07
-- EX 08
-- EX 09
-- EX 10
