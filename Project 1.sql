-- Bài 1
ALTER TABLE sales_dataset_rfm_prj ALTER COLUMN ordernumber TYPE numeric USING (trim(ordernumber)::numeric);
