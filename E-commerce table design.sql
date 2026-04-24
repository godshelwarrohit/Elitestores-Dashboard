CREATE DATABASE IF NOT EXISTS EliteStores;
USE EliteStores;

-- Section 1 : Table Design

-- ---------------------------------------------------
-- 1. Categories
-- ---------------------------------------------------
CREATE TABLE categories (	
		category_id INT PRIMARY KEY AUTO_INCREMENT,
        category_name VARCHAR (100) NOT NULL UNIQUE,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
		);
		
-- ---------------------------------------------------
-- 2. Customers
-- ---------------------------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT, 
	first_name VARCHAR (150) NOT NULL,
    last_name VARCHAR (150)NOT NULL,
    email VARCHAR (100) UNIQUE,
    phone VARCHAR (15),
    city VARCHAR (50),
    state VARCHAR (50),
    pincode VARCHAR(10),
    signup_date DATE,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );

-- ---------------------------------------------------
-- 3. Products
-- ---------------------------------------------------
CREATE TABLE products ( 
      product_id INT PRIMARY KEY AUTO_INCREMENT,
      product_name VARCHAR (150) NOT NULL,
      category_id INT NOT NULL,
      price DECIMAL (10,2),
      stock INT, 
      FOREIGN KEY (category_id) REFERENCES categories(category_id)
 );
 
 -- ---------------------------------------------------
 -- 4. orders
 -- ---------------------------------------------------
 CREATE TABLE orders (
       order_id INT PRIMARY KEY AUTO_INCREMENT,
       customer_id INT NOT NULL,
       order_date DATE NOT NULL DEFAULT (CURRENT_DATE),
       order_status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')
						NOT NULL DEFAULT ('pending'),
		created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
		updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ---------------------------------------------------
-- 5. Order_items
-- ---------------------------------------------------
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price Decimal (10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
 
 -- ---------------------------------------------------
 -- 6.Payments
 -- ---------------------------------------------------
CREATE TABLE payments (
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_mode ENUM('credit_card', 'debit_card', 'upi', 'cod', 'wallet', 'net_banking')
					NOT NULL,
    amount DECIMAL (10,2),
    payment_date DATE NOT NULL,
    payment_status ENUM('pending', 'failed', 'completed', 'refunded')
				NOT NULL,
	created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ---------------------------------------------------
-- 7. Shipping
-- ---------------------------------------------------
CREATE TABLE shipping (
    shipping_id       INT PRIMARY KEY AUTO_INCREMENT,
    order_id          INT         NOT NULL UNIQUE,
    address_line      VARCHAR(255) NOT NULL,
    city              VARCHAR(50),
    state             VARCHAR(50),
    pincode           VARCHAR(10),
    shipping_status   ENUM('not_shipped','in_transit','out_for_delivery','delivered','returned')
                      NOT NULL DEFAULT 'not_shipped',
    estimated_date    DATE,
    delivered_date    DATE,
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ---------------------------------------------------
-- 8. Reviews
-- ---------------------------------------------------
CREATE TABLE reviews (
    review_id   INT PRIMARY KEY AUTO_INCREMENT,
    product_id  INT NOT NULL,
    customer_id INT NOT NULL,
    rating      TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    UNIQUE (product_id, customer_id)   -- one review per customer per product
);
 
 -- ---------------------------------------------------
 -- 9. Coupons
 -- ---------------------------------------------------
CREATE TABLE coupons (
    coupon_id       INT PRIMARY KEY AUTO_INCREMENT,
    coupon_code     VARCHAR(30) NOT NULL UNIQUE,
    discount_pct    DECIMAL(5,2) NOT NULL CHECK (discount_pct BETWEEN 0 AND 100),
    valid_from      DATE NOT NULL,
    valid_until     DATE NOT NULL,
    max_uses        INT  NOT NULL DEFAULT 100,
    times_used      INT  NOT NULL DEFAULT 0,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP
); 
 
 -- ============================================================
-- SECTION 2: SAMPLE DATA
-- ============================================================
 
 INSERT INTO categories (category_name) VALUES
('Electronics'), ('Clothing'), ('Books'), ('Home & Kitchen'), ('Sports');

INSERT INTO customers (first_name, last_name, email, phone, city, state, pincode, signup_date) VALUES
('Aarav',   'Sharma',  'aarav.sharma@email.com',  '9876543210', 'Mumbai',    'Maharashtra', '400001', '2023-01-15'),
('Priya',   'Patel',   'priya.patel@email.com',   '9871234567', 'Ahmedabad', 'Gujarat',     '380001', '2023-02-20'),
('Rohan',   'Mehta',   'rohan.mehta@email.com',   '9812345678', 'Delhi',     'Delhi',       '110001', '2023-03-10'),
('Sneha',   'Iyer',    'sneha.iyer@email.com',    '9834567890', 'Chennai',   'Tamil Nadu',  '600001', '2023-04-05'),
('Vikram',  'Singh',   'vikram.singh@email.com',  '9845678901', 'Jaipur',    'Rajasthan',   '302001', '2023-05-22'),
('Anjali',  'Nair',    'anjali.nair@email.com',   '9856789012', 'Kochi',     'Kerala',      '682001', '2023-06-18'),
('Karan',   'Gupta',   'karan.gupta@email.com',   '9867890123', 'Pune',      'Maharashtra', '411001', '2023-07-30'),
('Meera',   'Joshi',   'meera.joshi@email.com',   '9878901234', 'Bengaluru', 'Karnataka',   '560001', '2023-08-12'),
('Arjun',   'Rao',     'arjun.rao@email.com',     '9889012345', 'Hyderabad', 'Telangana',   '500001', '2023-09-25'),
('Divya',   'Mishra',  'divya.mishra@email.com',  '9890123456', 'Lucknow',   'Uttar Pradesh','226001','2023-10-08');

INSERT INTO products (product_name, category_id, price, stock) VALUES
('Samsung Galaxy S23',      1,  79999.00, 50),
('Apple MacBook Air M2',    1, 114999.00, 30),
('Sony WH-1000XM5',         1,  29999.00, 75),
('Levi\'s 511 Slim Jeans',  2,   3499.00, 200),
('Nike Air Force 1',        2,   8999.00, 150),
('Atomic Habits',           3,    399.00, 500),
('Rich Dad Poor Dad',       3,    299.00, 400),
('Instant Pot Duo 7-in-1',  4,   8499.00, 60),
('Philips Air Fryer',       4,   6999.00, 80),
('Decathlon Yoga Mat',      5,    999.00, 300);

INSERT INTO orders (customer_id, order_date, order_status) VALUES
(1, '2024-01-10', 'delivered'),
(2, '2024-01-15', 'delivered'),
(3, '2024-02-05', 'delivered'),
(4, '2024-02-20', 'shipped'),
(5, '2024-03-01', 'delivered'),
(6, '2024-03-15', 'cancelled'),
(7, '2024-04-10', 'delivered'),
(8, '2024-04-22', 'delivered'),
(9, '2024-05-05', 'pending'),
(10,'2024-05-18', 'delivered'),
(1, '2024-06-01', 'delivered'),
(3, '2024-06-20', 'shipped');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,  1, 1, 79999.00),
(1,  6, 2,   399.00),
(2,  2, 1,114999.00),
(3,  3, 1, 29999.00),
(3,  7, 1,   299.00),
(4,  4, 2,  3499.00),
(5,  5, 1,  8999.00),
(6,  8, 1,  8499.00),
(7,  9, 1,  6999.00),
(7, 10, 2,   999.00),
(8,  1, 1, 79999.00),
(9,  2, 1,114999.00),
(10, 6, 3,   399.00),
(11, 3, 1, 29999.00),
(12, 5, 2,  8999.00);

INSERT INTO payments (order_id, payment_mode, amount, payment_date, payment_status) VALUES
(1,  'upi',         80797.00, '2024-01-10', 'completed'),
(2,  'credit_card',114999.00, '2024-01-15', 'completed'),
(3,  'net_banking',  30298.00,'2024-02-05', 'completed'),
(4,  'debit_card',   6998.00, '2024-02-20', 'completed'),
(5,  'upi',          8999.00, '2024-03-01', 'completed'),
(6,  'cod',          8499.00, '2024-03-15', 'refunded'),
(7,  'wallet',       8997.00, '2024-04-10', 'completed'),
(8,  'credit_card', 79999.00, '2024-04-22', 'completed'),
(9,  'upi',        114999.00, '2024-05-05', 'pending'),
(10, 'net_banking',  1197.00, '2024-05-18', 'completed'),
(11, 'upi',         29999.00, '2024-06-01', 'completed'),
(12, 'credit_card', 17998.00, '2024-06-20', 'completed');

INSERT INTO shipping (order_id, address_line, city, state, pincode, shipping_status, estimated_date, delivered_date) VALUES
(1,  '12 Marine Drive',     'Mumbai',    'Maharashtra', '400001', 'delivered',       '2024-01-13', '2024-01-12'),
(2,  '45 SG Highway',       'Ahmedabad', 'Gujarat',     '380001', 'delivered',       '2024-01-18', '2024-01-17'),
(3,  '7 Connaught Place',   'Delhi',     'Delhi',       '110001', 'delivered',       '2024-02-08', '2024-02-07'),
(4,  '22 Anna Salai',       'Chennai',   'Tamil Nadu',  '600001', 'in_transit',      '2024-02-23', NULL),
(5,  '56 MI Road',          'Jaipur',    'Rajasthan',   '302001', 'delivered',       '2024-03-04', '2024-03-03'),
(7,  '89 MG Road',          'Bengaluru', 'Karnataka',   '560001', 'delivered',       '2024-04-13', '2024-04-12'),
(8,  '34 Banjara Hills',    'Hyderabad', 'Telangana',   '500001', 'delivered',       '2024-04-25', '2024-04-24'),
(10, '67 Hazratganj',       'Lucknow',   'Uttar Pradesh','226001','delivered',       '2024-05-21', '2024-05-20'),
(11, '12 Marine Drive',     'Mumbai',    'Maharashtra', '400001', 'delivered',       '2024-06-04', '2024-06-03'),
(12, '7 Connaught Place',   'Delhi',     'Delhi',       '110001', 'out_for_delivery','2024-06-23', NULL);

INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date) VALUES
(1, 1, 5, 'Excellent phone, camera quality is top-notch!',          '2024-01-20'),
(2, 2, 5, 'Best laptop I have ever owned. M2 chip is blazing fast.','2024-01-25'),
(3, 3, 4, 'Great headphones, amazing noise cancellation.',           '2024-02-15'),
(6, 1, 5, 'Life-changing book. Highly recommended!',                 '2024-01-22'),
(5, 5, 4, 'Very comfortable shoes, true to size.',                   '2024-03-10'),
(9, 7, 4, 'Cooks food quickly and evenly.',                          '2024-04-20'),
(1, 8, 4, 'Good phone but battery life could be better.',            '2024-05-01'),
(7, 3, 3, 'Decent book but a bit repetitive.',                       '2024-02-18');

INSERT INTO coupons (coupon_code, discount_pct, valid_from, valid_until, max_uses, times_used) VALUES
('SAVE10',   10.00, '2024-01-01', '2024-12-31', 1000, 45),
('ELITE20',  20.00, '2024-03-01', '2024-06-30',  500, 23),
('NEWUSER15',15.00, '2024-01-01', '2024-12-31', 2000, 312);


-- ============================================================
-- SECTION 3: ANALYTICAL QUERIES
-- ============================================================

-- ------------------------------------------------------------
-- Q1. Top 5 customers by total revenue generated
-- ------------------------------------------------------------

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    c.city,
    COUNT(DISTINCT o.order_id)             AS total_orders,
    SUM(oi.quantity * oi.unit_price)       AS total_spent
FROM customers c
JOIN orders o       ON c.customer_id  = o.customer_id
JOIN order_items oi ON o.order_id     = oi.order_id
WHERE o.order_status != 'cancelled'
GROUP BY c.customer_id, customer_name, c.city
ORDER BY total_spent DESC
LIMIT 5;
  
-- ------------------------------------------------------------
-- Q2. Monthly revenue trend (Jan–Jun 2024)
-- ------------------------------------------------------------  
  SELECT
         DATE_FORMAT(o.order_date,  '%Y-%m')     AS month,
         COUNT(DISTINCT o.order_id)            AS total_orders,
         SUM(oi.quantity * oi.unit_price)       AS monthly_revenue
         FROM orders o
         JOIN order_items oi ON o.order_id = oi.order_id
         WHERE o.order_status != 'cancelled'
         GROUP BY month
         ORDER BY month;
  
 -- ------------------------------------------------------------
-- Q3. Best-selling products by quantity sold
-- ------------------------------------------------------------
 
SELECT 
		p.product_id,
        p.product_name,
        cat.category_name,
        SUM(oi.quantity)     AS total_qty_sold,
        SUM(oi.quantity * oi.unit_price)     AS total_revenue
        FROM order_items oi
        JOIN products p ON     oi.product_id = p.product_id
        JOIN categories cat ON 	p.category_id = cat.category_id
        JOIN orders o 	ON  	oi.order_id = o.order_id
        WHERE order_status != 'cancelled'
        GROUP BY p.product_id, p.product_name, cat.category_name
        ORDER BY total_qty_sold DESC;
	
        
-- ------------------------------------------------------------
-- Q4. Revenue contribution by product category
-- ------------------------------------------------------------

SELECT
		cat.category_name,
        SUM(oi.quantity * oi.unit_price)   AS category_revenue,
        ROUND(
				SUM(oi.quantity * oi.unit_price) *100.0/
                SUM(SUM(oi.quantity * oi.unit_price)) OVER (), 2
	)										AS revenue_pct
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status != 'cancelled'
    GROUP BY cat.category_name
    ORDER BY category_revenue DESC;
    
        
  -- ------------------------------------------------------------
-- Q5. Most popular payment modes
-- ------------------------------------------------------------
  
SELECT 
		payment_mode,
        COUNT(*) AS total_transactions,
        SUM(amount)  AS total_amount,
        ROUND(AVG(amount), 2)   AS avg_transaction_value
        FROM payments
        WHERE payment_status = 'completed'
        GROUP BY payment_mode
        ORDER BY total_transactions DESC;
        

-- ------------------------------------------------------------
-- Q6. Products low on stock (stock < 100)
-- ------------------------------------------------------------
SELECT
		p.product_id,
        p.product_name,
        cat.category_name,
        p.stock AS units_remaining,
        p.price
        FROM products p
        JOIN categories cat ON p.category_id = cat.category_id
        WHERE stock < 100
        ORDER BY p.stock ASC;
        
 -- ------------------------------------------------------------
-- Q7. Average product rating with total reviews
-- ------------------------------------------------------------
 
 SELECT 
       p.product_id,
       p.product_name,
       ROUND(AVG (r.rating) ,1 ) 		AS avg_rating,
       COUNT(review_id)  				AS total_reviews
       FROM products p
		LEFT JOIN reviews r ON p.product_id = r.product_id
        GROUP BY p.product_id, p.product_name
        ORDER BY avg_rating DESC, total_reviews DESC;
 
 
				-- --------------------------------------------------------------------
				--   Project by : Rohit Godshelwar
				-- Project Name : Database Design and Analysis of an e-commerce store
				-- ---------------------------------------------------------------------
 
        
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 