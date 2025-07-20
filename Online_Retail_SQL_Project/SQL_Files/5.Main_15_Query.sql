-- 1. Fetch customers with their order dates
SELECT c.first_name, c.last_name, o.order_date
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.first_name;

-- 2. List product names with brand and category
SELECT p.product_name, b.brand_name, c.category_name
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id;

-- 3. Show orders with staff names and store names
SELECT o.order_id, s.first_name || ' ' || s.last_name 
AS staff_name, st.store_name
FROM orders o
JOIN staffs s ON o.staff_id = s.staff_id
JOIN stores st ON o.store_id = st.store_id;

-- 4. Show all customers with or without orders
SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. List products with stock quantity per store
SELECT p.product_name, s.store_id, st.quantity
FROM products p
LEFT JOIN stocks st ON p.product_id = st.product_id
LEFT JOIN stores s ON st.store_id = s.store_id;

-- 6. Count total orders placed at each store
SELECT store_id, COUNT(*) AS total_orders
FROM orders
GROUP BY store_id;

-- 7. Calculate average product price by category
SELECT c.category_name, AVG(p.list_price) AS average_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- 8. Show top 5 most ordered products
SELECT p.product_name, SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_ordered DESC
LIMIT 5;

-- 9. List customers who haven't placed any orders
SELECT customer_id, first_name, last_name
FROM customers
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);

-- 10. Monthly order count
SELECT DATE_TRUNC('month', order_date) AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- 11. Show staff sales count
SELECT s.staff_id, s.first_name, COUNT(o.order_id) AS total_sales
FROM staffs s
LEFT JOIN orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name;

-- 12. Find stores with no stock of a specific product (e.g. product_id = 5)
SELECT store_id
FROM stores
WHERE store_id NOT IN (
  SELECT store_id FROM stocks WHERE product_id = 5
);

-- 13. Highest priced product in each category
SELECT c.category_name, MAX(p.list_price) AS highest_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;

-- 14. Average quantity sold per product
SELECT p.product_name, AVG(oi.quantity) AS avg_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name;

-- 15. Show each store's total stock value
SELECT s.store_id, SUM(p.list_price * st.quantity) AS total_stock_value
FROM stocks st
JOIN products p ON st.product_id = p.product_id
JOIN stores s ON st.store_id = s.store_id
GROUP BY s.store_id;
