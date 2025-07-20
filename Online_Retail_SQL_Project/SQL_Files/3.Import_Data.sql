-- Import data into brands table
COPY brands(brand_id, brand_name)
FROM 'D:/csv_files/brands.csv'
DELIMITER ','
CSV HEADER;

-- Import data into categories table
COPY categories(category_id, category_name)
FROM 'D:/csv_files/categories.csv'
DELIMITER ','
CSV HEADER;

-- Import data into customers table
COPY customers(customer_id, first_name, last_name, phone, email, street, city, state, zip_code)
FROM 'D:/csv_files/customers.csv'
DELIMITER ','
CSV HEADER;

-- Import data into order_items table
COPY order_items(order_id, item_id, product_id, quantity, list_price, discount)
FROM 'D:/csv_files/order_items.csv'
DELIMITER ','
CSV HEADER;

-- Import data into orders table
COPY orders(order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
FROM 'D:/csv_files/orders.csv'
DELIMITER ','
CSV HEADER;

-- Import data into products table
COPY products(product_id, product_name, brand_id, category_id, model_year, list_price)
FROM 'D:/csv_files/products.csv'
DELIMITER ','
CSV HEADER;

-- Import data into staffs table
COPY staffs(staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
FROM 'D:/csv_files/staffs.csv'
DELIMITER ','
CSV HEADER;

-- Import data into stocks table
COPY stocks(store_id, product_id, quantity)
FROM 'D:/csv_files/stocks.csv'
DELIMITER ','
CSV HEADER;

-- Import data into stores table
COPY stores(store_id, store_name, phone, email, street, city, state, zip_code)
FROM 'D:/csv_files/stores.csv'
DELIMITER ','
CSV HEADER;
