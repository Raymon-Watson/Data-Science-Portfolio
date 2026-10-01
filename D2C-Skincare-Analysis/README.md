# D2C Skincare E-Commerce Dataset Analysis

## Project Overview

This project analyses transaction data from a Direct-to-Consumer (D2C) skincare e-commerce business in order to understand regional sales performance, customer purchasing habits, and product performance.

PostgreSQL was used to organise, explore, and analyse the data. The analysis focuses on identifying revenue trends, high-value customers, product performance, and customer purchasing patterns.

## Business Problem

By analysing this data, we want to better understand its sales and customer base in order to improve revenue and customer retention.

Broad questions the analysis aims to answer:

- How is the revenue changing over time?
- Which products and categories generate the most revenue/profit?
- Which customers contribute the most revenue/profit?
- What population of customers make repeat purchases?

## Dataset

**Data source:**:  https://www.kaggle.com/datasets/kaushalvyas16/d2c-skincare-e-commerce-analytics-dataset

### Table grains

The dataset consists of 6 total files, however for this analysis we will be focusing on only 4 with the possibility of extension to include the additional 2 tables.

The table grains are as follows:
- Customers -> One row per customer
- Orders -> One row per order
- Order_Items -> One row per order / product within order
- Products -> One row per product

There are 2 additional tables, containing:
- Reviews -> One row per review (rating)
- Returns -> One row per returned order / product within returned order







## Database Structure

For a full breakdown of each table, along with the datatypes and brief explanation of each column in each table, see: **docs/data_dictionary.md**.

### Table relations

The relations between each table in this database are as follows:

customers\
&emsp;|\
&emsp;| customer_id\
&emsp;&darr;\
orders\
&emsp;|\
&emsp;| order_id\
&emsp;&darr;\
order_items\
&emsp;&uarr;\
&emsp;| product_id\
&emsp;|\
products


## Analysis Approach

The analysis was carried out in PostgreSQL using a relational dataset containing customers, products, orders, and order items.

The analysis followed four main stages:

1. **Data quality checks**
  - Checked for missing values, duplicates, and invalid values.
  - Reviewed table relational structure for consistency.

2. **Exploratory analysis**
  - Examined the size and time range of the dataset.
  - Explored customer locations, product categories, payment methods, and order statuses.

3. **Sales analysis**
  - Calculated total and monthly revenue.
  - Analysed average order value and order volume.
  - Examined month-over-month revenue growth as well as payment method and sales channel usage.
  
4. **Customer and product analysis**
  - Analysed customer spending and purchasing frequency.
  - Ranked customers by revenue contribution.
  - Analysed product sales, revenue, and discounts.

Cancelled orders were excluded from revenue calculations where appropriate.
Item-level revenue was calculated using quantity, product price, and discount, with shipping fees accounted for once per order.

## Key Findings


### Sales Performance
- Total non-cancelled revenue was $1,122,034.65
- Average order value prior to shipping and discount was $636.64
- Average order value after applying the discount was $575.59
- Revenue peaked in the months:
  - 2024 August, October, November
  - 2025 January, July, October
- Negative revenue growth was experienced in the months:
  - 2024 Feb, Apr, May, Jul, Sep, Nov, Dec
  - 2025 Feb, Apr, May, Jun, Aug, Sep, Nov

### Customer Behaviour
- Top 10 customers generated 3% of the total revenue
- 20% of customers only placed a single order
- Only 19 customers placed more than 5 orders

### Product Performance
- Alpha Arbutin 2% Serum generated most revenue, accounting for 7.96% of the total revenue
- All items had an average discount percentage around 10%
- Serum was by far the highest revenue product category, accounting for 45.6% of the revenue
- All other item categories had revenue percentages around or below 10%
- All products had at least one sale

### Order Analysis
- UPI was the most common payment method at 41.1%
- Website was by far most common sales avenue at 55.8%

## Recommendations

- **Focus on customer retention.**
  Around 20% of customers only ever placed a single order, suggesting that improving general
  customer retention may be valuable.
  
- **Investigate poorly performing products.**
  Products with very low or zero sales could be reviewed to determine whether they
  should be promoted, repositioned, or removed from the product range.

- **Prioritise high-performing product categories.**
  Categories consistently generating strong revenue, notably Serums, may warrant greater inventory,
  marketing, or promotional attention.

- **Investigate periods of declining revenue.**
  More than half the months in the year, in particular the first half of the year,
  had negative revenue growth. This should be further examined for changes in order
  volume, average order value, product mix, or cancellations.


## Reproducing the Analysis

The SQL files in this repository contain the queries used throughout the analysis.
They are organised by topic and are intended to document the analytical process as
well as allow the results to be reproduced if desired.

To reproduce the analysis:

1. Create a PostgreSQL database.
2. Create the required tables using `01_database_setup.sql`.
3. Import the provided CSV files into the corresponding tables.
4. Run the analysis files in numerical order:

   - `02_data_quality.sql`
   - `03_exploration.sql`
   - `04_sales_analysis.sql`
   - `05_customer_analysis.sql`
   - `06_product_analysis.sql`

The SQL files do not need to be run as a single pipeline. Each file contains
independent analytical queries that can be executed individually in PostgreSQL,
for example using pgAdmin.

Key results and conclusions from the analysis are summarised in the
**Key Findings** section of this README.

## SQL Skills Demonstrated

This project uses:

- SELECT, WHERE and CASE
- GROUP BY and HAVING
- aggregate functions
- date manipulation
- INNER and LEFT JOIN
- subqueries
- Common Table Expressions (CTEs)
- conditional aggregation
- RANK
- LAG and LEAD
- windowed SUM and AVG
- rolling calculations
