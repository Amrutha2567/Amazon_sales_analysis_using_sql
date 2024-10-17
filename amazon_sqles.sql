-- Create a new database
CREATE DATABASE AmazonSalesData;

-- Use the newly created database
USE AmazonSalesData;

-- Create the sales_transactions table
CREATE TABLE sales_transactions (
    invoice_id VARCHAR(30) NOT NULL,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATE NOT NULL,
    time TIMESTAMP NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_percentage FLOAT(11, 9) NOT NULL,
    gross_income DECIMAL(10, 2) NOT NULL,
    rating FLOAT(2, 1) NOT NULL
);

-- Example of inserting a row (replace with actual data inserts)
INSERT INTO sales_transactions (invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, VAT, total, date, time, payment_method, cogs, gross_margin_percentage, gross_income, rating) 
VALUES ('INV001', 'B1', 'Mandalay', 'Member', 'Female', 'Health and Beauty', 100.00, 2, 10.0000, 220.00, '2024-08-01', '2024-08-01 10:00:00', 'Credit Card', 200.00, 0.1, 20.00, 8.5);

SELECT *
FROM sales_transactions
WHERE invoice_id IS NULL
   OR branch IS NULL
   OR city IS NULL
   OR customer_type IS NULL
   OR gender IS NULL
   OR product_line IS NULL
   OR unit_price IS NULL
   OR quantity IS NULL
   OR VAT IS NULL
   OR total IS NULL
   OR date IS NULL
   OR time IS NULL
   OR payment_method IS NULL
   OR cogs IS NULL
   OR gross_margin_percentage IS NULL
   OR gross_income IS NULL
   OR rating IS NULL;

/*--What is the count of distinct cities in the dataset?*/
SELECT COUNT(DISTINCT city) AS distinct_cities
FROM sales_transactions;

SELECT DISTINCT branch, city
FROM sales_transactions;

SELECT COUNT(DISTINCT product_line) AS distinct_product_lines
FROM sales_transactions;

SELECT product_line, SUM(quantity) AS total_sales
FROM sales_transactions
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

SELECT product_line, SUM(total) AS total_revenue
FROM sales_transactions
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT 1;

SELECT product_line, SUM(VAT) AS total_vat
FROM sales_transactions
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

WITH avg_sales AS (
    SELECT AVG(total) AS avg_total_sales
    FROM sales_transactions
)
SELECT product_line,
       CASE
           WHEN SUM(total) > (SELECT avg_total_sales FROM avg_sales) THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM sales_transactions
GROUP BY product_line;

SELECT payment_method, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY payment_method
ORDER BY frequency DESC
LIMIT 1;

SELECT monthname, SUM(total) AS monthly_revenue
FROM sales_transactions
GROUP BY monthname
ORDER BY STR_TO_DATE(monthname, '%M');

SELECT monthname, SUM(cogs) AS total_cogs
FROM sales_transactions
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;


SELECT customer_type, SUM(total) AS total_revenue
FROM sales_transactions
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

SELECT customer_type, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;


SELECT customer_type, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;

SELECT customer_type, COUNT(*) AS purchase_frequency
FROM sales_transactions
GROUP BY customer_type
ORDER BY purchase_frequency DESC
LIMIT 1;


SELECT gender, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY gender
ORDER BY frequency DESC
LIMIT 1;


SELECT branch, gender, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY branch, gender
ORDER BY branch, frequency DESC;

SELECT customer_type, SUM(VAT) AS total_vat
FROM sales_transactions
GROUP BY customer_type
ORDER BY total_vat DESC
LIMIT 1;

WITH avg_quantity AS (
    SELECT AVG(quantity) AS avg_quantity
    FROM sales_transactions
)
SELECT branch, SUM(quantity) AS total_quantity
FROM sales_transactions
GROUP BY branch
HAVING total_quantity > (SELECT avg_quantity FROM avg_quantity);


SELECT dayname, timeofday, COUNT(*) AS sales_occurrences
FROM sales_transactions
GROUP BY dayname, timeofday
ORDER BY dayname, timeofday;

SELECT timeofday, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY timeofday
ORDER BY avg_rating DESC
LIMIT 1;

SELECT branch, timeofday, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY branch, timeofday
ORDER BY branch, avg_rating DESC;


SELECT dayname, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;


SELECT branch, dayname, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY branch, dayname
ORDER BY branch, avg_rating DESC;

-- Add timeofday column
ALTER TABLE sales_transactions ADD COLUMN timeofday VARCHAR(20);

-- Update timeofday values based on the time column
UPDATE sales_transactions
SET timeofday = CASE
    WHEN TIME(time) BETWEEN '06:00:00' AND '12:00:00' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:01' AND '18:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Add dayname column
ALTER TABLE sales_transactions ADD COLUMN dayname VARCHAR(10);

-- Update dayname values based on the date column
UPDATE sales_transactions
SET dayname = DAYNAME(date);

-- Add monthname column
ALTER TABLE sales_transactions ADD COLUMN monthname VARCHAR(20);

-- Update monthname values based on the date column
UPDATE sales_transactions
SET monthname = MONTHNAME(date);

-- Feature Engineering: Adding 'timeofday' column and updating based on time of sales
ALTER TABLE sales_transactions
ADD COLUMN timeofday VARCHAR(20);

UPDATE sales_transactions
SET timeofday = CASE
    WHEN TIME(time) BETWEEN '06:00:00' AND '12:00:00' THEN 'Morning'
    WHEN TIME(time) BETWEEN '12:00:01' AND '18:00:00' THEN 'Afternoon'
    ELSE 'Evening'
END;

-- Feature Engineering: Adding 'dayname' column to extract the day of the week
ALTER TABLE sales_transactions
ADD COLUMN dayname VARCHAR(10);

UPDATE sales_transactions
SET dayname = DAYNAME(date);

-- City and Branch Analysis: Count of distinct cities
SELECT COUNT(DISTINCT city) AS distinct_cities
FROM sales_transactions;

-- City and Branch Analysis: Corresponding city for each branch
SELECT DISTINCT branch, city
FROM sales_transactions;

-- Product Line and Sales Analysis: Count of distinct product lines
SELECT COUNT(DISTINCT product_line) AS distinct_product_lines
FROM sales_transactions;

-- Payment Method Analysis: Most frequent payment method
SELECT payment_method, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY payment_method
ORDER BY frequency DESC
LIMIT 1;

-- Product Line Analysis: Product line with the highest sales (by total sales amount)
SELECT product_line, SUM(total) AS total_sales
FROM sales_transactions
GROUP BY product_line
ORDER BY total_sales DESC
LIMIT 1;

-- Payment Method and Revenue Analysis: Monthly revenue
SELECT monthname, SUM(total) AS monthly_revenue
FROM sales_transactions
GROUP BY monthname
ORDER BY STR_TO_DATE(monthname, '%M');

-- COGS Analysis: Month with the highest COGS
SELECT monthname, SUM(cogs) AS total_cogs
FROM sales_transactions
GROUP BY monthname
ORDER BY total_cogs DESC
LIMIT 1;

-- VAT Analysis: Product line with the highest VAT
SELECT product_line, SUM(VAT) AS total_vat
FROM sales_transactions
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- Product Line Performance: Add 'Good'/'Bad' performance based on average sales
WITH avg_sales AS (
    SELECT AVG(total) AS avg_total_sales
    FROM sales_transactions
)
SELECT product_line,
       CASE
           WHEN SUM(total) > (SELECT avg_total_sales FROM avg_sales) THEN 'Good'
           ELSE 'Bad'
       END AS performance
FROM sales_transactions
GROUP BY product_line;

-- Branch Performance: Identify branch that exceeded the average number of products sold
WITH avg_quantity AS (
    SELECT AVG(quantity) AS avg_quantity
    FROM sales_transactions
)
SELECT branch, SUM(quantity) AS total_quantity
FROM sales_transactions
GROUP BY branch
HAVING total_quantity > (SELECT avg_quantity FROM avg_quantity);

-- Gender Analysis: Most frequent product line for each gender
SELECT gender, product_line, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY gender, product_line
ORDER BY gender, frequency DESC;

-- Rating Analysis: Average rating for each product line
SELECT product_line, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY product_line;

-- Sales Occurrences: Count sales occurrences for each time of day on every weekday
SELECT dayname, timeofday, COUNT(*) AS sales_occurrences
FROM sales_transactions
GROUP BY dayname, timeofday
ORDER BY dayname, timeofday;

-- Customer Revenue: Customer type contributing the highest revenue
SELECT customer_type, SUM(total) AS total_revenue
FROM sales_transactions
GROUP BY customer_type
ORDER BY total_revenue DESC
LIMIT 1;

-- VAT Analysis: City with the highest average VAT percentage
SELECT city, AVG(VAT) AS avg_vat_percentage
FROM sales_transactions
GROUP BY city
ORDER BY avg_vat_percentage DESC
LIMIT 1;

-- VAT Payments: Customer type with the highest VAT payments
SELECT customer_type, SUM(VAT) AS total_vat
FROM sales_transactions
GROUP BY customer_type
ORDER BY total_vat DESC
LIMIT 1;

-- Distinct Customer Types: Count of distinct customer types
SELECT COUNT(DISTINCT customer_type) AS distinct_customer_types
FROM sales_transactions;

-- Distinct Payment Methods: Count of distinct payment methods
SELECT COUNT(DISTINCT payment_method) AS distinct_payment_methods
FROM sales_transactions;

-- Most Frequent Customer Type: Customer type with the highest purchase frequency
SELECT customer_type, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY customer_type
ORDER BY frequency DESC
LIMIT 1;

-- Predominant Gender: Determine the predominant gender among customers
SELECT gender, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY gender
ORDER BY frequency DESC
LIMIT 1;

-- Gender Distribution: Examine the distribution of genders within each branch
SELECT branch, gender, COUNT(*) AS frequency
FROM sales_transactions
GROUP BY branch, gender
ORDER BY branch, frequency DESC;

-- Time of Day and Ratings: Identify the time of day when customers provide the most ratings
SELECT timeofday, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY timeofday
ORDER BY avg_rating DESC
LIMIT 1;

-- Branch and Time Analysis: Determine the time of day with the highest customer ratings for each branch
SELECT branch, timeofday, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY branch, timeofday
ORDER BY branch, avg_rating DESC;

-- Day and Rating Analysis: Identify the day of the week with the highest average ratings
SELECT dayname, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY dayname
ORDER BY avg_rating DESC
LIMIT 1;

-- Branch and Day Rating Analysis: Determine the day of the week with the highest average ratings for each branch
SELECT branch, dayname, AVG(rating) AS avg_rating
FROM sales_transactions
GROUP BY branch, dayname
ORDER BY branch, avg_rating DESC;
