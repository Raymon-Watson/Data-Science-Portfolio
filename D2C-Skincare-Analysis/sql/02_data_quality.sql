-- ##########################
--     02 Data quality
-- ##########################


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1. Are primary keys unique
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- customers: PK = customer_id
SELECT COUNT(*),
COUNT(DISTINCT customer_id)
FROM customers;
-- 500 distinct customer id's.
-- matches the number of rows (consistent).

-- orders: PK = order_id
SELECT COUNT(*),
COUNT(DISTINCT order_id)
FROM orders;
-- 1250 distinct order id's.
-- Matches the number of rows (consistent).

-- order_items: PK = order_item_id
SELECT COUNT(*),
COUNT(DISTINCT order_item_id)
FROM order_items;
-- 2024 order item id's.
-- Consistent.

-- products: PK = product_id
SELECT COUNT(*),
COUNT(DISTINCT product_id)
FROM products;
-- 28 products.
-- Consistent.

-- ~~~~~~~~~~~~~~~~~~~~~~~~~
-- 2. Are any values missing
-- ~~~~~~~~~~~~~~~~~~~~~~~~~

-- Customers:
SELECT COUNT(*) AS num_rows,
COUNT(customer_id) AS num_id,
COUNT(customer_name) AS num_name,
COUNT(city) AS num_city,
COUNT(customer_state) AS num_state,
COUNT(signup_date) AS num_signup
FROM customers;
-- No missing values

-- Orders:
SELECT COUNT(*) AS num_rows,
COUNT(order_id) AS num_order_id,
COUNT(customer_id) AS customer_id,
COUNT(order_date) AS num_state,
COUNT(order_status) AS num_status,
COUNT(payment_method) AS num_pay,
COUNT(sales_channel) AS num_sales,
COUNT(gross_amount) AS num_gross,
COUNT(discount_amount) AS num_disc,
COUNT(shipping_fee) AS num_ship,
COUNT(final_amount) AS num_final,
COUNT(delivered_date) AS num_deliv
FROM orders;
-- num_deliv = 1099 (Missing = 1250 - 1099 = 151)
-- Why are there missing values?
SELECT * FROM orders
WHERE delivered_date IS NULL;
-- No delivery date for order_status = Cancelled, In Transit

-- Order_items:
SELECT COUNT(*) AS num_rows,
COUNT(order_item_id) AS num_order_item_id,
COUNT(order_id) AS num_order_id,
COUNT(product_id) AS num_prod_id,
COUNT(quantity) AS num_quant,
COUNT(unit_price) AS num_unit,
COUNT(discount_pct) AS num_disc,
COUNT(item_total) AS num_total
FROM order_items;
-- No missing values


-- Products:
SELECT COUNT(*) AS num_rows,
COUNT(product_id) AS num_id,
COUNT(product_name) AS num_name,
COUNT(category) AS num_cat,
COUNT(skin_type) AS num_skin,
COUNT(key_ingredient) AS num_key,
COUNT(product_size) AS num_size,
COUNT(mrp) AS num_mrp,
COUNT(cost_price) AS num_cost,
COUNT(stock_qty) AS num_stock,
COUNT(launch_date) AS num_launch
FROM products;
-- No missing values

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3. Are there impossible quantities
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Orders:
SELECT * FROM orders
WHERE gross_amount <= 0
 OR discount_amount < 0
 OR shipping_fee < 0
 OR final_amount <= 0;
-- There are rows where the final_amount is 0.
-- However, these are cancelled orders.
-- No impossible quantities.

-- Order_items:
SELECT * FROM order_items
WHERE quantity <= 0
	OR unit_price <= 0 
	OR discount_pct < 0
	OR item_total <= 0;
-- No impossible quantities.
-- NOTE: item_total will be non-zero even for cancelled orders.
-- i.e. cancellation only contained in orders table.

-- Products:
SELECT * FROM products
WHERE mrp <= 0
	OR cost_price <= 0
	OR stock_qty < 0;
-- No impossible quantities.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 4. Do any orders refer to non-existent customers
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT * FROM orders AS o
LEFT JOIN customers AS c
	ON o.customer_id = c.customer_id
WHERE c.customer_name IS NULL;
-- No orders refer to nonexistent customers.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 5. Do all orders match to order_items
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT * FROM orders AS o
LEFT JOIN order_items AS oi
	ON o.order_id = oi.order_id
WHERE oi.order_item_id IS NULL;
-- All orders match to order items.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 6. Do all order_items match a product
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT * FROM order_items AS oi
LEFT JOIN products AS p
	ON oi.product_id = p.product_id
WHERE p.product_name IS NULL;
-- All order items match a product.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 7. Overall data quality assessment
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- All data is consistent, entirely numerically valid,
-- and the table relational integrity is sound.
-- No issues found.
