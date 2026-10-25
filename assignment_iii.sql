-- ASSIGNMENT III: SQL TABLE MANIPULATION
-- Student: UWASE Nadia (202512339)
-- Project: Clothes Shop (PostgreSQL)


-- =====================================
-- 1. DATABASE CREATION
-- =====================================
CREATE DATABASE uwasenadia_202512339_clothes_shop;
-- (then open a Query Tool on this new database and run the rest)


-- =====================================
-- 2. TABLE CREATION AND CONSTRAINTS
-- =====================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(35),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price INT CHECK (price > 0),
    stock INT DEFAULT 0
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    product_id INT NOT NULL REFERENCES products(product_id),
    quantity INT CHECK (quantity > 0),
    order_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'pending'
);

-- ERD generated here (before the ALTER TABLE tasks)


-- =====================================
-- 3. INITIAL DATA INSERTION
-- =====================================
INSERT INTO customers (full_name, phone, city) VALUES
('Aline Uwase', '0788111222', 'Kigali'),
('Jean Habimana', '0788333444', 'Huye'),
('Grace Mukamana', '0788555666', 'Kigali'),
('Eric Nshimiyimana', '0788777888', 'Musanze'),
('Diane Ingabire', '0788999000', 'Rubavu');

INSERT INTO products (product_name, category, price, stock) VALUES
('Blue Jeans', 'Trousers', 15000, 20),
('White T-Shirt', 'Shirts', 6000, 35),
('Black Dress', 'Dresses', 25000, 10),
('Sneakers', 'Shoes', 30000, 15),
('Leather Belt', 'Accessories', 5000, 40),
('Hoodie', 'Jackets', 22000, 12);

INSERT INTO orders (customer_id, product_id, quantity, order_date, status) VALUES
(1, 1, 2, '2026-10-02', 'delivered'),
(2, 4, 1, '2026-10-05', 'pending'),
(3, 3, 1, '2026-10-10', 'pending'),
(1, 2, 3, '2026-10-18', 'delivered'),
(4, 6, 1, '2026-10-22', 'pending'),
(3, 5, 2, '2026-10-23', 'pending');

-- check that every table has at least 5 rows
SELECT 'customers' AS table_name, COUNT(*) AS total FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders;

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;


-- =====================================
-- 4. SELECT TASKS
-- =====================================

-- Q1.1 Basic retrieval: name, category and price of all products
SELECT product_name, category, price FROM products;

-- Q1.2 Conditional retrieval: products that cost more than 20000
SELECT product_name, price FROM products WHERE price > 20000;

-- Q1.3 Sorted retrieval: products from cheapest to most expensive
SELECT product_name, price FROM products ORDER BY price ASC;


-- =====================================
-- 5. JOIN TASKS
-- =====================================

-- Q2.1 INNER JOIN: orders with the name of the customer
SELECT o.order_id, c.full_name, o.quantity, o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- Q2.2 LEFT JOIN: all customers, even the ones without orders
SELECT c.full_name, o.order_id, o.status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Q2.3 Multi-table JOIN: who bought what and the total price
SELECT c.full_name, p.product_name, o.quantity, p.price * o.quantity AS total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id;


-- =====================================
-- 6. UPDATE TASKS AND VERIFICATION
-- =====================================

-- Q3.1 Update one record: new price for Blue Jeans
SELECT product_name, price FROM products WHERE product_name = 'Blue Jeans';  -- before
UPDATE products SET price = 16000 WHERE product_name = 'Blue Jeans';
SELECT product_name, price FROM products WHERE product_name = 'Blue Jeans';  -- after

-- Q3.2 Update multiple records: add 10 to the stock of shoes and accessories
SELECT product_name, stock FROM products WHERE category IN ('Shoes', 'Accessories');  -- before
UPDATE products SET stock = stock + 10 WHERE category IN ('Shoes', 'Accessories');
SELECT product_name, stock FROM products WHERE category IN ('Shoes', 'Accessories');  -- after

-- Q3.3 Conditional update: pending orders made before 20 Oct are now delivered
SELECT order_id, order_date, status FROM orders WHERE status = 'pending' AND order_date < '2026-10-20';  -- before
UPDATE orders SET status = 'delivered' WHERE status = 'pending' AND order_date < '2026-10-20';
SELECT order_id, order_date, status FROM orders ORDER BY order_id;  -- after


-- =====================================
-- 7. ALTER TABLE TASKS AND VERIFICATION
-- =====================================

-- Q4.1 Rename a column: phone -> phone_number
ALTER TABLE customers RENAME COLUMN phone TO phone_number;
SELECT * FROM customers;

-- Q4.2 Change a data type: price from INT to NUMERIC(10,2)
ALTER TABLE products ALTER COLUMN price TYPE NUMERIC(10,2);
SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'products';
SELECT product_name, price FROM products;

-- Q4.3 Add a column: size of the product
ALTER TABLE products ADD COLUMN size VARCHAR(5);
SELECT * FROM products;


-- =====================================
-- 8. ADDITIONAL INSERT TASKS AND VERIFICATION
-- =====================================

-- Q5.1 Insert a single record: one new customer
INSERT INTO customers (full_name, phone_number, city) VALUES ('Patrick Niyonzima', '0788123456', 'Kigali');
SELECT * FROM customers;

-- Q5.2 Insert multiple records: three new products
INSERT INTO products (product_name, category, price, stock, size) VALUES
('Red Skirt', 'Skirts', 12000, 8, 'M'),
('Kitenge Shirt', 'Shirts', 18000, 14, 'L'),
('Cap', 'Accessories', 4000, 30, 'S');
SELECT * FROM products;

-- Q5.3 Insert a related record: new order for customer 6 and product 2
INSERT INTO orders (customer_id, product_id, quantity) VALUES (6, 2, 2);
SELECT * FROM orders;
