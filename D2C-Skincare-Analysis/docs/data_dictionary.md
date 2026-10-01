# Data Dictionary

## Customers
**Location:** data/Customers.csv

|Column|Type|Description|
|-|-|-|
|customer_id| Text | Unique customer id (PRIMARY KEY)|
|customer_name| Text | Customer name (First Last)|
|city|Text |City of customer |
|state|Text|State of customer|
|gender|Text|Gender of customer (Male/Female/Other)|
|age_group|Text|Age group of customer (e.g. 18-24, 34-44, 45+)|
|signup_date|Date|Date of customer signup (dd/mm/yyyy)|
|acquisition channel|Text| Where the user found the website (e.g. Google search, Instagram, etc.)|

## Order items
**Location:** data/Order_Items.csv

|Column|Type|Description|
|-|-|-|
|order_item_id|Text| Unique id for the order / item|
|order_id|Text| Order id (not unique)|
|product_id|Text| Product id|
|quantity|Int| Quantity of particular purchased item|
|unit_price|Int| Price of single item|
|discount_pct|Int| Discount percentage|
|item_total|Numeric| Total price of items in row =(unit_price*quantity)*(1 - discount_pct/100)|



## Orders
**Location:** data/Orders.csv

|Column|Type|Description|
|-|-|-|
|order_id| Text| Unique order id|
|customer_id| Text| Customer id|
|order_date| Date | Date of order (dd/mm/yyyy)|
|order_status|Text|Current status of order (e.g. Delivered/In Transit/Cancelled)|
|payment_method|Text|Method of payment (e.g. Debit Card/ Credit Card/ UPI/...)|
|sales_channel| Text | Where product was purchased (e.g. Mobile App/ Website/...)|
|gross_amount|Numeric|Total charge of all items (discount included)|
|discount_amount|Numeric| Amount discounted|
|shipping_fee|Int|Shipping cost|
|final_amount|Numeric|Total cost of purchase =gross_amount + shipping_fee|
|delivered_date|Date| Date of order delivery (dd/mm/yyyy) (Missing if cancelled / in transit)|



## Products
**Location:** data/Products.csv

|Column|Type|Description|
|-|-|-|
|product_id|Text|Unique product id|
|product_name|Text|Product name|
|category|Text|Product category (e.g. Serum/Mousturizer/...)|
|concern|Text| Concern the product is designed for (e.g. Acne control/anti-ageing/...)|
|skin_type|Text|Type of skin product is suited for (e.g. All Skin Types/ Oily/... Can be multiple)|
|key_ingredient|Text|Key ingredient of product (e.g. Retinot)|
|size|Text|Volume of product (ml or g)|
|mrp|Int| Maximum retail price|
|cost_price|Int| Asked price for product|
|stock_qty|Int| Amount of product in stock|
|launch_date|Date| Date of product launch (dd/mm/yyyy)|





