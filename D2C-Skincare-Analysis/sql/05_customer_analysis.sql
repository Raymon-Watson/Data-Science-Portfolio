-- ##########################
--   05 Customer analysis
-- ##########################


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1.  Customer Summary
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- To aid in the following analysis, we start with 
-- an overall customer summary, containing:
-- customer_id
-- customer_name
-- number_of_orders
-- total_spent
-- spending_rank
-- average_order_value
-- first_order
-- last_order

SELECT c.customer_id,
	c.customer_name,
	COUNT(o.order_id) AS num_orders,
	RANK() OVER(ORDER BY SUM(o.final_amount) DESC) AS spending_rank,
	SUM(o.final_amount) AS total_spent,
	ROUND(AVG(SUM(o.final_amount)) OVER(),2) AS avg_total_spent,
	ROUND(AVG(o.final_amount),2) AS average_order_value,
	MIN(o.order_date) AS first_order,
	MAX(o.order_date) AS last_order
FROM customers AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- We find that only 199 customers have spent more than the 
-- average total amount. Recalling that there are 500 total
-- customers, this accounts for less than half.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 2. Customers Without Purchases
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- First, we find a list of all customers without orders:
SELECT * FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Let's count the number of customers:
SELECT COUNT(*) FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- Overall, 46 customers have never placed an order.
-- This accounts for nearly 10% of the 500 customers.

-- Let's also check the number of cancelled orders,
-- since this effectively counts as a non-order:
SELECT COUNT(*) FROM orders
WHERE order_status = 'Cancelled';
-- 86 total cancelled orders, out of a total 1250.
-- Not an enormous amount.



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3.  Non-Repeat Customers
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- It would be interesting to see how many customers
-- do not order a second time. Perhaps an issue is
-- customer retention.

-- First, we count the number of customers who have
-- only a single order. This is simple enough that we
-- don't need to use a CTE, and can instead subquery.

SELECT COUNT(*) FROM (
	SELECT c.customer_id,
		COUNT(o.order_id) AS num_orders
	FROM customers AS c
	INNER JOIN orders AS o
		ON c.customer_id = o.customer_id
	GROUP BY c.customer_id
)
WHERE num_orders = 1;
-- Overall, 102 customers have never repeat ordered.
-- This seems to be a significant amount of the customer
-- base (~20%), suggesting the need to improve customer retention.

-- We also provide a list of the customers without repeat orders:
SELECT c.customer_id,
	c.customer_name,
	COUNT(o.order_id) AS num_orders
FROM customers AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) = 1;



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 4.  Repeat Customers
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Finally, we look at the customers who did repeat, ranking
-- them by their number of orders, and comparing this against
-- the average number of orders.
SELECT c.customer_id,
	c.customer_name,
	COUNT(o.order_id) AS num_orders,
	ROUND(AVG(COUNT(o.final_amount)) OVER(),2) AS avg_num_orders,
	RANK() OVER(ORDER BY COUNT(o.final_amount) DESC) AS rank_num_order
FROM customers AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- There are only 19 customers who ordered more than 5 times.
-- This is significantly less than the number of customers who
-- either ordered only once or no times.

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 5.  Spending Tiers
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(final_amount) AS total_spent
    FROM orders
    WHERE order_status != 'Cancelled'
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_spent,
    CASE
        WHEN total_spent >= 5000 THEN 'High Value'
        WHEN total_spent >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent DESC;
-- According to the above (somewhat arbitrary) classification,
-- only 38 of the overall 500 customers are considered High Value.
-- In contrast, as shown below, 196 of the customers could be considered Low Value.

WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(final_amount) AS total_spent
    FROM orders
    WHERE order_status != 'Cancelled'
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_spent,
    CASE
        WHEN total_spent >= 5000 THEN 'High Value'
        WHEN total_spent >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM customer_spending
ORDER BY total_spent ASC;





-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 5.  Top 10 Customers
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- First, I will create a summary table of the top 10 customers,
-- including revenue percentage.
WITH customer_summary AS (
SELECT c.customer_id,
	c.customer_name,
	COUNT(o.order_id) AS num_orders,
	RANK() OVER(ORDER BY SUM(o.final_amount) DESC) AS spending_rank,
	SUM(o.final_amount) AS total_spent,
	ROUND(AVG(SUM(o.final_amount)) OVER(),2) AS avg_total_spent,
	ROUND(AVG(o.final_amount),2) AS average_order_value
FROM customers AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id
),
top_10_customers AS (
SELECT *,
ROUND(100 * (total_spent / (SUM(total_spent) OVER ())),2) AS customer_pct
FROM customer_summary
LIMIT 10
)
SELECT * FROM top_10_customers;


-- Next, I will use the above to calculate the total percentage that
-- the top 10 customers contributed to the total revenue.

WITH customer_summary AS (
SELECT c.customer_id,
	c.customer_name,
	COUNT(o.order_id) AS num_orders,
	RANK() OVER(ORDER BY SUM(o.final_amount) DESC) AS spending_rank,
	SUM(o.final_amount) AS total_spent,
	ROUND(AVG(SUM(o.final_amount)) OVER(),2) AS avg_total_spent,
	ROUND(AVG(o.final_amount),2) AS average_order_value
FROM customers AS c
INNER JOIN orders AS o
	ON c.customer_id = o.customer_id
GROUP BY c.customer_id
),
top_10_customers AS (
SELECT *,
ROUND(100 * (total_spent / (SUM(total_spent) OVER ())),2) AS customer_pct
FROM customer_summary
LIMIT 10
)
SELECT SUM(customer_pct) FROM top_10_customers;

-- Overall, the top 10 customers generated 3% of the revenue.
