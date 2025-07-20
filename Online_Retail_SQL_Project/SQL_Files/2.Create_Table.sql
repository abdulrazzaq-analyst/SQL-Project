
CREATE TABLE brands (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(25)
);


CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(30)
);


CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    phone VARCHAR(30),
    email VARCHAR(100) UNIQUE,
    street VARCHAR(150),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code INT
);

CREATE TABLE order_items (
    order_id INT,
    item_id INT,
    product_id INT,
    quantity INT,
    list_price NUMERIC(10,2),
    discount INT,
    PRIMARY KEY (order_id, item_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    brand_id INT,
    category_id INT,
    model_year INT,
    list_price NUMERIC(10,2),
    FOREIGN KEY (brand_id) REFERENCES brands(brand_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);


CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    phone INT,
    email VARCHAR(100) UNIQUE,
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(10),
    zip_code INT
);

CREATE TABLE staffs (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    email VARCHAR(100) UNIQUE,
    phone INT,
    active INT,
    store_id INT,
    manager_id INT,
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (manager_id) REFERENCES staffs(staff_id) -- self-reference
);


CREATE TABLE stocks (
    store_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_status INT,
    order_date DATE,
    required_date DATE,
    shipped_date DATE,
    store_id INT,
    staff_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
);

