-- ================================
--         Project Setup
-- ================================


-- ######## 1. Remove pre-existing tables ########
-- CAREFUL: This will delete these tables.
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;







-- ######## 2. Create core tables ########

CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY,
  customer_name TEXT,
  city TEXT,
  customer_state TEXT,
  gender TEXT,
  age_group TEXT,
  signup_date DATE,
  acquisition_channel TEXT
);


CREATE TABLE products (
  product_id TEXT PRIMARY KEY,
  product_name TEXT,
  category TEXT,
  concern TEXT,
  skin_type TEXT,
  key_ingredient TEXT,
  product_size TEXT,
  mrp INT,
  cost_price INT,
  stock_qty INT,
  launch_date DATE
);


CREATE TABLE orders (
  order_id TEXT PRIMARY KEY,
  customer_id TEXT,
  order_date DATE,
  order_status TEXT,
  payment_method TEXT,
  sales_channel TEXT,
  gross_amount NUMERIC,
  discount_amount NUMERIC,
  shipping_fee INT,
  final_amount NUMERIC,
  delivered_date DATE,

  FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);


CREATE TABLE order_items (
  order_item_id TEXT PRIMARY KEY,
  order_id TEXT,
  product_id TEXT,
  quantity INT,
  unit_price INT,
  discount_pct INT,
  item_total NUMERIC,

  FOREIGN KEY (order_id)
    REFERENCES orders(order_id),

  FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);



-- ######## 3. Basic checks ########

SELECT * FROM customers
LIMIT 10;


SELECT * FROM order_items
LIMIT 10;


SELECT * FROM orders
LIMIT 10;


SELECT * FROM products
LIMIT 10;
