# Retail Sales Analysis SQL Portfolio Project

An end-to-end data analysis project demonstrating core data engineering and analytics skills using **PostgreSQL**. This project covers the complete lifecycle from database setup and data cleaning to exploratory data analysis (EDA) and advanced analytical querying.

---

## 📌 Project Overview

* **Project Title**: Retail Sales Analysis
* **Level**: Intermediate / Engineering-Grade Portfolio
* **Database**: `Retail Sale Analyis Project`
* **Tooling**: PostgreSQL

This project simulates a real-world retail analytics workflow. It ingests raw transaction logs, validates data integrity by removing null records, and answers crucial business questions using subqueries, Common Table Expressions (CTEs), window functions , and conditional aggregation.

---

## 🛠️ Objectives & Methodology

1. **Database Setup**: Create and structure a relational transactional database (`p1_retail_db`) with proper primary keys and data types.
2. **Data Cleaning**: Audit for missing or null values across all attributes and remove incomplete rows to ensure analysis accuracy.
3. **Exploratory Data Analysis (EDA)**: Understand customer demographics, unique reach, and product category distributions.
4. **Advanced Business Analysis**: Leverage window functions and CTEs to solve complex analytical challenges like year-over-year trends and shift-based volume distributions.

---

## 🗄️ 1. Database Setup

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(15),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

---

## 🧹 2. Data Cleaning & Validation

Before running analytics, we verify the dataset size and purge any records containing `NULL` values across critical fields.

```sql
-- Check total row count and null values
SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
    category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

-- Remove incomplete records
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR 
    customer_id IS NULL OR gender IS NULL OR age IS NULL OR 
    category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

---

## 🔍 3. Business Problems & SQL Solutions

### Q1: Retrieve all columns for sales made on `'2022-11-05'`
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2: Retrieve transactions where category is 'Clothing' and quantity sold is $\ge 4$ in Nov 2022
```sql
SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND quantity >= 4;
```

### Q3: Calculate total net sales and order volume for each category
```sql
SELECT 
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category
ORDER BY net_sale DESC;
```

### Q4: Find the average age of customers who purchased from the 'Beauty' category
```sql
SELECT 
    ROUND(CAST(AVG(age) AS NUMERIC), 2) AS avg_beauty_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5: Find all transactions where `total_sale` is greater than 1000
```sql
SELECT * 
FROM retail_sales
WHERE total_sale > 1000
ORDER BY total_sale DESC;
```

### Q6: Count total transactions by gender in each category
```sql
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

### Q7: Calculate average sales per month and identify the best-selling month in each year using window functions
```sql
WITH avg_monthly_sale AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY 1, 2
),
ranked_monthly_sale AS (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) AS best_month_rank
    FROM avg_monthly_sale
)
SELECT 
    year,
    month,
    ROUND(CAST(avg_sale AS NUMERIC), 2) AS average_sale
FROM ranked_monthly_sale
WHERE best_month_rank = 1;
```

### Q8: Find the top 5 customers based on highest total sales
```sql
SELECT 
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Q9: Find the number of unique customers who purchased items from each category
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

### Q10: Categorize orders into shifts and count order volume (`CASE WHEN`)
* *Morning*: Hour $< 12$
* *Afternoon*: Hour between 12 and 17
* *Evening*: Hour $> 17$

```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;
```

---

## 📈 Key Insights & Findings

* **Category Performance**: High-ticket product categories drive the majority of net revenue, with clear demand spikes identified during specific months.
* **Customer Demographics**: Purchases span diverse age cohorts, with robust engagement in both Clothing and Beauty sectors.
* **Peak Operations**: Time-of-day shift segmentation reveals peak purchasing windows, providing actionable insights for staffing or inventory promotions.

---

## 🚀 How to Run the Project

1. Clone this repository to your local machine.
2. Spin up your **PostgreSQL** instance (via pgAdmin, DBeaver, or terminal).
3. Execute the SQL script files sequentially to build the schema, sanitize records, and generate analytical outputs.

---

## 👤 Author & Portfolio Context

Built as part of an engineering-grade data analytics portfolio demonstrating structured data hygiene, advanced SQL querying patterns, and business intelligence reporting. Connect or reach out for feedback and collaboration!