-- Retail Sales Analysis SQL Project


-- Create table
DROP TABLE IF EXISTS retail_sales;
Create table retail_sales(
			transactions_id INT PRIMARY KEY,	
			sale_date Date,
			sale_time Time,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantiy INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
);

SELECT * from retail_sales; 

-- Data Cleaning

select * from retail_sales
where 
	transactions_id is null
	or 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

--
delete from retail_sales
where 
	transactions_id is null
	or 
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

select count(*) from retail_sales

-- Data Exploration

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales
where sale_date = '2022-11-05'

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where 
	  category = 'Clothing' 
	  and 
	  quantiy >= 4 
	  and 
	  TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- 3.Write a SQL query to calculate the total sales (total_sale) for each category.

select
	category,
	SUM(total_sale) as net_sale
from retail_sales
GROUP BY category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(AVG(age),2) as Avg_age
from retail_sales
where category = 'Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retail_sales
where
	total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	category,
	gender,
	Count(transactions_id) as Transactions
from retail_sales
Group by gender,category;

f
select avg(sale) as Avg_sale
from retail_sales

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH avg_monthly_sale AS(
	-- Step 1: Calculate the average sale amount for each year and month
	SELECT 
		EXTRACT (YEAR FROM sale_date) as year,
		EXTRACT (MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale
	FROM retail_sales
	GROUP BY year,month
	ORDER BY year,month
),
	ranked_monthly_sale AS(
	-- Step 2: Rank months within each year by their average sale in descending order
	SELECT 
		year,
		month,
		avg_sale,
		RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) AS best_month
	FROM avg_monthly_sale
)
	-- Step 3: Filter for the top-ranked (best-selling) month for each year
SELECT 
	year,
	month,
	best_month	
FROM ranked_monthly_sale
WHERE best_month = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH shifts AS(
	SELECT 
		sale_time,
		CASE
			WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM shifts
GROUP BY shift
ORDER BY total_orders
;

-- END OF PROJECT