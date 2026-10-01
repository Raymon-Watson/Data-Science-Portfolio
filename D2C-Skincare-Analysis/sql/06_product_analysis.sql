-- ##########################
--    06 Product analysis
-- ##########################

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1. Product Summary
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- We begin by providing an overall summary table,
-- which will be useful in the following analysis.

-- This table contains:
-- product_id
-- product_name
-- category
-- units_sold
-- revenue
-- avg_discount
-- percentage_of_revenue
-- revenue_rank

-- Because this involves a number of steps, we break down
-- the logic by using a CTE.

-- First, we create a CTE that calculates the relevant quantities:
WITH product_data AS (
SELECT p.product_id,
	p.product_name,
	p.category,
	SUM(i.quantity) AS units_sold,
	SUM(i.quantity * p.mrp * (1 - CAST(i.discount_pct AS NUMERIC)/100) ) AS total_revenue, -- Total revenue including discount
	ROUND(AVG( CAST(discount_pct AS NUMERIC)),2) AS avg_discount -- Average discount for each individual item
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') -- Make sure to not include orders that were cancelled or returned
GROUP BY p.product_id
)
-- Next, we use the above calculated total revenue to find both the rank according 
-- to total revenue, as well as the percent that this revenue contributes to the total for all items.
SELECT product_id, 
	product_name, 
	category, 
	units_sold,
	ROUND(total_revenue,2),
	RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
	ROUND((total_revenue / (SUM(total_revenue) OVER ()))*100,2) AS revenue_percent,
	avg_discount
FROM product_data;

-- From this, we find that there are only 7 items that contribute more than 5%
-- to the total revenue.
-- 7 items consist of less than 2% revenue each.

-- The average discount is quite high across all items.
-- This likely rules out increasing discounts as a means
-- to increase customer retention.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 2. Product units sold
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Complete table of units sold per product:


-- Top 10 sold products:

SELECT p.product_id, 
	p.product_name,
	SUM(i.quantity) AS units_sold
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') 
GROUP BY p.product_id
ORDER BY units_sold DESC
LIMIT 10;


-- Bottom 10 sold products:

SELECT p.product_id, 
	p.product_name,
	SUM(i.quantity) AS units_sold
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') 
GROUP BY p.product_id
ORDER BY units_sold ASC
LIMIT 10;


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3. Product Revenue
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~



-- Top 10 revenue products:

SELECT p.product_id,
	p.product_name,
	p.category,
	SUM(i.quantity) AS units_sold,
	ROUND(SUM(i.quantity * p.mrp * (1 - CAST(i.discount_pct AS NUMERIC)/100) ),2) AS total_revenue
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') -- Make sure to not include orders that were cancelled or returned
GROUP BY p.product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- The highest selling product brings in $81,027.65 total revenue



-- Bottom 10 revenue products:
SELECT p.product_id,
	p.product_name,
	p.category,
	SUM(i.quantity) AS units_sold,
	ROUND(SUM(i.quantity * p.mrp * (1 - CAST(i.discount_pct AS NUMERIC)/100) ),2) AS total_revenue
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') -- Make sure to not include orders that were cancelled or returned
GROUP BY p.product_id
ORDER BY total_revenue ASC
LIMIT 10;

-- The lowest selling product still brings in
-- $10,872.75 total revenue


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 4. Products with no sales
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~


SELECT p.product_id FROM products AS p
LEFT JOIN order_items AS i
	ON p.product_id = i.product_id
WHERE i.order_id IS NULL;

-- Every single item has been sold at least once.



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 5. Products by category
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~


WITH product_data AS (
SELECT p.category,
	SUM(i.quantity * p.mrp * (1 - CAST(i.discount_pct AS NUMERIC)/100) ) AS total_revenue -- Total revenue including discount
FROM products AS p
INNER JOIN order_items AS i
	ON p.product_id = i.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Returned') -- Make sure to not include orders that were cancelled or returned
GROUP BY p.product_id
)
-- Next, we use the above calculated total revenue to find both the rank according 
-- to total revenue, as well as the percent that this revenue contributes to the total for all items.
SELECT category, 
	ROUND(SUM(total_revenue),2) AS category_revenue,
	ROUND(
    	100 * SUM(total_revenue)
    	/ SUM(SUM(total_revenue)) OVER (),
    	2) AS category_revenue_pct	FROM product_data
GROUP BY category
ORDER BY category_revenue DESC;


