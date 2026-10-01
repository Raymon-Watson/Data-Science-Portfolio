-- ##########################
--     04 Sales analysis
-- ##########################


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1. Total Revenue
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- We begin by calculating the Total Revenue accrued
-- over the entire time the business has been taking
-- orders.



-- First, note that the orders table contains
-- gross_amount and final_amount columns.
-- These can be used to calculate:
-- (1) Gross Revenue (including discount but NOT shipping fees)
-- (2) Final Revenue (including both discount AND shipping fees)

-- Often the above is not available.
-- I therefore begin by calculating both Gross Revenue
-- and Final Revenue without these columns.

-- Following this, these values will be checked
-- against these columns from the order tables.



-- (1) Calculate Gross Revenue:
-- Note: since discount_pct is INT, it is
-- simpler to use a CTE to cast as NUMERIC first.

-- First, to calculate the total cost, we need the product price (mrp)
-- along with the quantity ordered and the discount percent:
WITH discount_numeric AS (
SELECT i.quantity,
p.mrp,
CAST(i.discount_pct AS NUMERIC) -- Convert discount_pct to numeric
FROM order_items AS i
INNER JOIN products AS p
	ON i.product_id = p.product_id
)
-- Next, we calculate the total price including the discount:
SELECT ROUND(SUM(quantity * mrp ), 2),
ROUND(SUM(quantity * mrp * ( 1 - discount_pct/100) ), 2)
FROM discount_numeric;

-- Total price before discount = $1,300,021.00
-- Total price after discount = $1,175,350.00


SELECT * FROM products
LIMIT 5;


-- (2) Calculate Final Revenue:
-- The final revenue includes the shipping fee.
-- NOTE: shipping fee must only be included once per order.
-- NOTE: Cancelled orders are fully refunded.

-- First we must again cast the discount percent as numeric.
-- We must also remove all cancelled orders.
-- The above can be easily done via CTE.
WITH collated_orders AS (
SELECT i.quantity,
p.mrp,
CAST(i.discount_pct AS NUMERIC),
o.order_status,
i.order_id
FROM order_items AS i
INNER JOIN products AS p
	ON i.product_id = p.product_id
INNER JOIN orders AS o
	ON i.order_id = o.order_id
WHERE order_status != 'Cancelled'
),
-- Next, to apply the shipping fee ONCE PER ORDER, we can
-- use a second CTE to group orders.
grouped_orders AS (
SELECT order_id AS order_id,
SUM(quantity * mrp * ( 1 - discount_pct/100)) AS gross_total
FROM collated_orders
GROUP BY order_id
)
-- Add shipping fee to grouped orders.
SELECT ROUND(SUM(gross_total + shipping_fee),2) FROM grouped_orders
JOIN orders
	ON grouped_orders.order_id = orders.order_id;
	
-- Final revenue = $1,122,034.65


-- Count the number of orders per customer
-- Show the customer id and customer name
-- Number of orders each customer placed




-- (3) Check against orders table:
-- We can now use the gross_amount and final_amount
-- to compare our above calculations.
SELECT SUM(gross_amount) AS gross_revenue,
SUM(final_amount) AS final_revenue
FROM orders;
-- Gross_revenue = $1,175,350.00
-- Final_revenue = $1,122,034.65
-- These exactly match that calculated above.


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 2. Average order value
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- To calculate the average order value,
-- we first look at the amount generated prior to
-- applying the discount and shipping fees:

SELECT ROUND(AVG(i.quantity * p.mrp),2) FROM order_items as i
INNER JOIN products AS p
	ON i.product_id = p.product_id;
-- This gives an average order value of $636.64


-- Accounting for the discount, this is reduced to
SELECT ROUND(AVG(quantity * mrp * ( 1 - discount_pct/100)),2)
FROM (
SELECT p.mrp,
i.quantity,
CAST(i.discount_pct AS NUMERIC)
FROM order_items as i
INNER JOIN products AS p
	ON i.product_id = p.product_id
)
-- This gives an average order value after discount of $575.59





-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 3. Revenue by month
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Now we move to a finer-grained analysis of the revenue,
-- breaking it down by month.
-- Note that we make use of the fact that the orders table 
-- contains final_amount to calculate the total revenue per 
-- month. This is done to make the following analysis simpler
-- to analyse.

-- Calculate the revenue for each month across the two
-- years of available data.
-- For context, we also provide the yearly total revenue.

-- First, use a CTE to collect the monthly revenue.
WITH order_by_month AS (
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
EXTRACT(MONTH FROM order_date) AS order_month,
SUM(final_amount) AS monthly_revenue
FROM orders
GROUP BY order_year, order_month)
-- Next, we present this data along with the average
-- yearly revenue for both years using a window function:
SELECT order_year, order_month, monthly_revenue,
	ROUND(AVG(monthly_revenue)
	OVER (PARTITION BY order_year),2)
	AS yearly_revenue
FROM order_by_month
ORDER BY order_year, order_month ASC;

-- From the above, we find that the majority of months
-- lie below the average yearly revenue in both years.
-- The overall average is brought up significantly by:
-- 2024 August, October, November
-- 2025 January, July, October.

-- Also note that the yearly average goes down by ~$3000
-- from 2024 to 2025.



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 4. Month-over-month growth
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- To provide further details on the above, we calculate the
-- month-over-month growth percent.


-- To do this we require a combination of CTE's and nested
-- window functions.

-- We start by calculating the monthly revenue via CTE
WITH monthly_orders AS (
	SELECT EXTRACT(YEAR FROM order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	ROUND(SUM(final_amount),2) AS monthly_revenue
	FROM orders
	GROUP BY order_year, order_month
)
-- For each month, we provide the monthly revenue,
-- the previous month's revenue (using LAG),
-- and the month-over-month precentage growth
-- (using LAG and nested window functions)
SELECT order_year, 
	order_month,
	monthly_revenue, 
	LAG(monthly_revenue) OVER 
	(ORDER BY order_year, order_month)
	AS previous_month_revenue,
	ROUND(100*((monthly_revenue - LAG(monthly_revenue) OVER 
	(ORDER BY order_year, order_month)  )
	/LAG(monthly_revenue) OVER
	(ORDER BY order_year, order_month)) ,2)
	AS monthly_growth
FROM monthly_orders;


-- This confirms the enormous spikes that we see
-- in the months mentioned in the previous section.
-- These months often see a growth of over 100%.

-- Interestingly, the month-over-month growth swings
-- quite dramatically nearly every month, suggesting
-- that the business is quite unstable.


-- Months with negative growth:
-- 2024 Feb, Apr, May, Jul, Sep, Nov, Dec
-- 2025 Feb, Apr, May, Jun, Aug, Sep, Nov
-- More than half the year!






-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 5. Num. orders by month
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~


-- First, we look at total orders per month.
-- Using a CTE in combination with a window
-- function, we can query each month's revenue
-- and compare it with the average.

WITH order_per_month AS (
	SELECT EXTRACT(YEAR FROM order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	COUNT(*) AS num_orders
	FROM orders
	GROUP BY order_year, order_month
)
SELECT order_year,
	order_month,
	num_orders,
	ROUND(AVG(num_orders) OVER(PARTITION BY order_year),2) AS avg_yearly_revenue
	FROM order_per_month
	ORDER BY order_year, order_month;

-- Again we see a consistent pattern with the months:
-- 2024 August, October, November
-- 2025 January, July, October
-- Having a larger number of orders than any other
-- months, bringing up the overall average.






-- ~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 6. Revenue Breakdown
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~

-- For further analyses, we can look at:

-- (1) Cumulative revenue:

-- We can find the cumulative revenue by month, year
-- similarly to the above.
-- First extract month, year.
WITH monthly_orders AS (
	SELECT EXTRACT(YEAR FROM order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	ROUND(SUM(final_amount),2) AS monthly_revenue
	FROM orders
	GROUP BY order_year, order_month
)
SELECT order_year, order_month,
	SUM(monthly_revenue) OVER 
	(ORDER BY order_year, order_month)
	AS cumulative_revenue
FROM monthly_orders;


-- (2) Rolling 3-month revenue:

WITH monthly_orders AS (
	SELECT EXTRACT(YEAR FROM order_date) AS order_year,
	EXTRACT(MONTH FROM order_date) AS order_month,
	ROUND(SUM(final_amount),2) AS monthly_revenue
	FROM orders
	GROUP BY order_year, order_month
) 
SELECT order_year, order_month,
	monthly_revenue,
	ROUND(AVG(monthly_revenue) OVER
	( ORDER BY order_year, order_month
	ROWS BETWEEN 3 PRECEDING AND CURRENT ROW),2)
	AS rolling_average
FROM monthly_orders;

-- From these it is clear that the performance during the 
-- first half of both years is significantly below
-- that of the second half.






-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 7. Most common payment method
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT payment_method, 
	COUNT(*) AS payment_count
FROM orders
GROUP BY payment_method
ORDER BY payment_count DESC;
-- UPI (unified payments interface) is by far the
-- most common payment method. (Note: this is specific
-- to India, as this payment method is developed there).


-- To get a percent value for the above, we can use window functions:
SELECT payment_method, 
	COUNT(*) AS payment_count,
	ROUND(100 * COUNT(*)/SUM(COUNT(*)) OVER(),2) AS payment_pct
FROM orders
GROUP BY payment_method
ORDER BY payment_pct DESC;
-- From this, we find UPI accounts for 41.1% of the payment methods.



-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 8. Most common sales channel
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SELECT sales_channel, 
	COUNT(*) AS sales_count
FROM orders
GROUP BY sales_channel
ORDER BY sales_count DESC;
-- The most common sales channel is via Website.
-- By far the least common is via Marketplace.

-- To get a percent of total channels, we can use a window function.
SELECT sales_channel, 
	COUNT(*) AS sales_count,
	ROUND(100 * COUNT(*)/SUM(COUNT(*)) OVER(),2) AS channel_pct
FROM orders
GROUP BY sales_channel
ORDER BY channel_pct DESC;
-- From this, we find that orders from the Website account for
-- 55.8% of the overall sales. And Marketplace only 8.64%.




-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 9. Cancelled Orders
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT
	EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    COUNT(*) AS total_orders,
    COUNT(
        CASE
            WHEN order_status = 'Cancelled' THEN 1
        END
    ) AS cancelled_orders,
    COUNT(
        CASE
            WHEN order_status != 'Cancelled' THEN 1
        END
    ) AS non_cancelled_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

-- We see a surprising spike in the number of cancelled orders
-- during November 2024 and August 2025, where the number of
-- cancelled orders exceeds 10.
-- It is perhaps interesting that the months where the largest
-- number of cancelled orders occur is also during the months
-- of highest revenue. This is likely due to an increase of
-- the total number of orders, meaning that the proportion of
-- cancelled orders is roughly constant.

-- To check this last assertion, we can look at the proportion
-- of cancelled orders:
WITH orders_cancelled AS (
SELECT
	EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    COUNT(*) AS total_orders,
    COUNT(
        CASE
            WHEN order_status = 'Cancelled' THEN 1
        END
    ) AS cancelled_orders
FROM orders
GROUP BY order_year, order_month
ORDER BY order_year, order_month)
SELECT *,
	ROUND(100*CAST(cancelled_orders AS NUMERIC)/
	CAST(total_orders AS NUMERIC),2)
FROM orders_cancelled;

-- The above assertion is not actually true. There seems to
-- be a spike in the proportion of cancelled orders
-- during these months.
