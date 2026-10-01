-- ##########################
--     02 Exploration
-- ##########################


-- ~~~~~~~~~~~~
-- 1. Customers
-- ~~~~~~~~~~~~

SELECT * FROM customers
LIMIT 5;

SELECT COUNT(*) FROM customers;
-- Num. customers = 500

SELECT COUNT(DISTINCT city) FROM customers;
-- Num. cities = 20

SELECT COUNT(DISTINCT customer_state) FROM customers;
-- Num. states = 13

-- Num. customer in each city
SELECT city, COUNT(customer_id) FROM customers
GROUP BY city
ORDER BY COUNT(customer_id) DESC;
-- Most customers: Indore, 34
-- Least customers: Chennai, 16

-- Num customer in each state
SELECT customer_state, COUNT(customer_id) FROM customers
GROUP BY customer_state
ORDER BY COUNT(customer_id) DESC;
-- Most customers: Maharashtra, 78
-- Least customer: Telangana, 18

SELECT MIN(signup_date),
MAX(signup_date)
FROM customers;
-- First signup = 2023-01-01
-- Last signup = 2024-11-30




-- ~~~~~~~~~
-- 2. Orders
-- ~~~~~~~~~

-- Number of orders
SELECT COUNT(*),
COUNT(DISTINCT order_id)
FROM orders;
-- Num. orders = 1250
-- Each row contains one distinct order

-- Order date range
SELECT MIN(order_date),
MAX(order_date)
FROM orders;
-- First order = 2024-01-01
-- Last order = 2025-12-31

-- Order statuses
SELECT DISTINCT order_status FROM orders;
-- Order types: 
-- Delivered
-- Returned
-- Cancelled
-- In Transit

-- Payment methods
SELECT DISTINCT payment_method FROM orders;
-- Payment types: 
-- Net banking
-- UPI
-- Debit Card
-- COD
-- Credit Card

-- Sales channels
SELECT DISTINCT sales_channel FROM orders;
-- Sales channels:
-- Marketplace
-- Mobile App
-- Website

-- Delivery date range
SELECT MIN(delivered_date),
MAX(delivered_date)
FROM orders;
-- First delivered date = 2024-01-06
-- Latest delivered date = 2026-01-07




-- ~~~~~~~~~~~~~~
-- 3. Order Items
-- ~~~~~~~~~~~~~~

SELECT * FROM order_items
LIMIT 5;

SELECT MIN(quantity),
MAX(quantity),
AVG(quantity)
FROM order_items;
-- Min quantity = 1
-- Max quantity = 3

SELECT MIN(num_items),
MAX(num_items),
AVG(num_items)
FROM (
SELECT order_id, 
SUM(quantity) AS num_items
FROM order_items
GROUP BY order_id
);
-- Min total items = 1
-- Max total items = 7
-- Avg total items = 2.06

SELECT MIN(discount_pct),
MAX(discount_pct),
AVG(discount_pct)
FROM order_items;
-- Min discount = 0
-- Max discount - 25
-- Avg discount = 9.60
-- Note: discounts are applied to individual items.


-- ~~~~~~~~~~~
-- 4. Products
-- ~~~~~~~~~~~

SELECT * FROM products
LIMIT 5;

SELECT COUNT(*) FROM products;
-- Num products = 28

SELECT COUNT(DISTINCT category) FROM products;
-- Num categories = 9

SELECT COUNT(DISTINCT key_ingredient) FROM products;
-- Num key_ingredient = 25

SELECT DISTINCT product_size FROM products;
-- Num product_size = 8
-- Given in ml or g

SELECT MIN(mrp),
MAX(mrp),
AVG(mrp)
FROM products;
-- Min mrp = 249
-- Max mrp = 799
-- Avg mrp = 491.86

SELECT MIN(cost_price),
MAX(cost_price),
AVG(cost_price)
FROM products;
-- Min cost_price = 92
-- Max cost_price = 372
-- Avg cost_price = 212.54

SELECT MIN(mrp - cost_price),
MAX(mrp - cost_price),
AVG(mrp - cost_price)
FROM products;
-- Min mrp-cost diff. = 157
-- Max mrp-cost diff. = 441
-- Avg mrp-cost diff. = 279.32

SELECT MIN(stock_qty),
MAX(stock_qty),
AVG(stock_qty)
FROM products;
-- Min stock = 110
-- Max stock = 350
-- Avg stock = 210.89


SELECT MIN(launch_date),
MAX(launch_date)
FROM products;
-- First launch = 2021-08-16
-- Latest launch = 2023-12-12
