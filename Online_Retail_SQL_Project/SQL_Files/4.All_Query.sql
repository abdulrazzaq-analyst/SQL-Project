-- List first name, city, and email of customers from California
SELECT first_name, city, email FROM customers WHERE city = 'California';

-- Show store names and zip codes where zip code is greater than 60000
SELECT store_id, zip_code FROM stores WHERE zip_code > 60000;

-- Find all products with a list price less than 500
SELECT * FROM products WHERE list_price < 500;

-- Customer Order Date
SELECT c.first_name, c.last_name, o.order_date 
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.first_name;

-- Product, Brand & Category Mapping
SELECT p.product_name, b.brand_name, c.category_name 
FROM products p
JOIN brands b ON b.brand_id = p.brand_id 
JOIN categories c ON c.category_id = p.category_id;

-- Orders with Staff and Store Info
SELECT o.*, st.first_name, st.last_name, so.store_name 
FROM orders o
JOIN staffs st ON o.staff_id = st.staff_id
JOIN stores so ON o.store_id = so.store_id;

-- Product Stock by Store
SELECT s.store_id, s.store_name, p.product_name, q.quantity 
FROM stocks q
JOIN stores s ON s.store_id = q.store_id
JOIN products p ON q.product_id = p.product_id;

-- All Customers (With or Without Orders)
SELECT c.first_name, c.last_name, o.order_id 
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- All Orders with Customer Details (Even if Customer Missing)
SELECT o.order_id, c.* 
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id;

-- All Products with Stock Quantity (Even if Not in Stock)
SELECT p.product_name, s.quantity 
FROM products p
LEFT JOIN stocks s ON p.product_id = s.product_id;

-- Combine all emails from customers and staff into one list
SELECT COALESCE(c.email, s.email) AS email 
FROM staffs s
FULL OUTER JOIN customers c ON s.email = c.email;

-- Total Orders per Store
SELECT store_id, COUNT(order_id) 
FROM orders 
GROUP BY store_id;

-- Total Quantity Sold per Product
SELECT product_id, SUM(quantity) 
FROM order_items 
GROUP BY product_id 
ORDER BY product_id;

-- Average Product Price by Category
SELECT c.category_id, c.category_name, AVG(p.list_price) 
FROM products p
RIGHT JOIN categories c ON c.category_id = p.category_id 
GROUP BY c.category_id, c.category_name 
ORDER BY c.category_id;

-- Brands with Average Product Price > 1000
SELECT b.brand_id, b.brand_name, AVG(p.list_price) 
FROM brands b
LEFT JOIN products p ON b.brand_id = p.brand_id 
GROUP BY b.brand_id, b.brand_name 
ORDER BY b.brand_id;

-- Top 5 Most Expensive Products
SELECT * FROM products 
ORDER BY list_price DESC 
LIMIT 5;

-- Products Ordered by Total Quantity Sold
SELECT product_id, SUM(quantity) 
FROM order_items 
GROUP BY product_id 
ORDER BY SUM(quantity) DESC;

-- Customers with Total Order Amount Above Average
SELECT o.customer_id, SUM(i.list_price) 
FROM order_items i 
JOIN orders o ON o.order_id = i.order_id 
GROUP BY o.customer_id 
HAVING SUM(i.list_price) > (SELECT AVG(list_price) FROM order_items) 
ORDER BY o.customer_id;

-- Highest Priced Product per Category
SELECT c.category_name, MAX(p.list_price) 
FROM products p
JOIN categories c ON c.category_id = p.category_id 
GROUP BY c.category_name;

-- Stores with Less Than 10 Products in Stock
SELECT s.store_name, COUNT(t.product_id) 
FROM stores s
JOIN stocks t ON s.store_id = t.store_id 
GROUP BY s.store_name 
HAVING COUNT(t.product_id) < 10;
