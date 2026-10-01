-- DATABASE SETUP

-- TABLE CREATION

CREATE TABLE Customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city          VARCHAR(50),
    email         VARCHAR(100)
);

CREATE TABLE Products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    category      VARCHAR(50),
    price         DECIMAL(10,2),
    created_date  DATE
);

CREATE TABLE Orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT,
    product_id   INT,
    quantity     INT,
    order_date   DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- SAMPLE DATA

INSERT INTO Customers VALUES
(1,  'Aarav Sharma',   'Pune',      'aarav@example.com'),
(2,  'Priya Patel',    'Mumbai',    'priya@example.com'),
(3,  'Rohan Mehta',    'Delhi',     'rohan@example.com'),
(4,  'Sneha Iyer',     'Chennai',   'sneha@example.com'),
(5,  'Vikram Singh',   'Jaipur',    'vikram@example.com'),
(6,  'Ananya Rao',     'Bengaluru', 'ananya@example.com'),
(7,  'Karan Verma',    'Lucknow',   'karan@example.com'),
(8,  'Meera Nair',     'Kochi',     'meera@example.com'),
(9,  'Rahul Joshi',    'Nagpur',    'rahul@example.com'),
(10, 'Divya Kulkarni', 'Nashik',    'divya@example.com');

INSERT INTO Products VALUES
(1,  'Laptop',          'Electronics', 55000.00, '2024-01-15'),
(2,  'Smartphone',      'Electronics', 25000.00, '2024-03-10'),
(3,  'Headphones',      'Electronics',  2500.00, '2023-11-05'),
(4,  'Office Chair',    'Furniture',    7500.00, '2024-02-20'),
(5,  'Study Desk',      'Furniture',    6500.00, '2023-08-12'),
(6,  'Bookshelf',       'Furniture',    4200.00, '2024-05-01'),
(7,  'T-Shirt',         'Clothing',      599.00, '2024-06-18'),
(8,  'Jeans',           'Clothing',     1499.00, '2023-12-25'),
(9,  'Novel',           'Books',         350.00, '2022-09-09'),
(10, 'Python Handbook', 'Books',         899.00, '2024-04-04'),
(11, 'Sneakers',        'Clothing',     2999.00, '2024-07-07');

INSERT INTO Orders VALUES
(1,  1, 1,  1, '2024-01-20'),
(2,  1, 3,  2, '2024-02-11'),
(3,  2, 2,  1, '2024-03-15'),
(4,  2, 7,  3, '2024-03-16'),
(5,  3, 4,  1, '2024-04-02'),
(6,  3, 5,  1, '2024-04-05'),
(7,  4, 8,  2, '2024-04-20'),
(8,  4, 10, 1, '2024-05-03'),
(9,  5, 9,  4, '2024-05-15'),
(10, 5, 6,  1, '2024-05-18'),
(11, 6, 11, 1, '2024-06-01'),
(12, 6, 3,  1, '2024-06-10'),
(13, 7, 2,  1, '2024-06-25'),
(14, 7, 7,  2, '2024-07-04'),
(15, 8, 10, 2, '2024-07-12'),
(16, 8, 1,  1, '2024-07-20'),
(17, 1, 8,  1, '2024-08-01'),
(18, 2, 9,  2, '2024-08-09'),
(19, 3, 3,  1, '2024-08-15'),
(20, 4, 11, 2, '2024-08-25');

-- SECTION 1: ADVANCED JOINS

-- Task 1: Display each customer along with the products they ordered.

SELECT c.customer_name, p.product_name, o.quantity, o.order_date
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
INNER JOIN Products p ON o.product_id = p.product_id
ORDER BY c.customer_name;

-- Task 2: Display all possible combinations of customers and products.

SELECT c.customer_name, p.product_name
FROM Customers c
CROSS JOIN Products p;

-- Task 3: Display all customers and their orders, including customers

SELECT c.customer_id, c.customer_name, o.order_id, o.product_id,
       o.quantity, o.order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- SECTION 2: SUBQUERIES

-- Task 4: Find products priced above the average product price.

SELECT product_id, product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- Task 5: Display customers whose total purchase amount is greater

SELECT c.customer_id, c.customer_name,
       SUM(p.price * o.quantity) AS total_purchase
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(p.price * o.quantity) > (
    SELECT AVG(t.total)
    FROM (
        SELECT SUM(p2.price * o2.quantity) AS total
        FROM Orders o2
        JOIN Products p2 ON o2.product_id = p2.product_id
        GROUP BY o2.customer_id
    ) t
);

-- Task 6: Find the highest-priced product in each category

SELECT p.category, p.product_name, p.price
FROM Products p
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM Products p2
    WHERE p2.category = p.category
);

-- SECTION 3: SET OPERATIONS

-- Task 7: Combine products from two different categories using UNION.

SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Electronics'
UNION
SELECT product_id, product_name, category, price
FROM Products
WHERE category = 'Furniture';

-- Task 8a: MySQL alternative for INTERSECT using INNER JOIN.

SELECT c.customer_id, c.customer_name
FROM (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Electronics'
) a
INNER JOIN (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Clothing'
) b ON a.customer_id = b.customer_id
INNER JOIN Customers c ON c.customer_id = a.customer_id;

-- Task 8b: MySQL alternative for EXCEPT using LEFT JOIN.

SELECT c.customer_id, c.customer_name
FROM (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Electronics'
) a
LEFT JOIN (
    SELECT DISTINCT o.customer_id
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE p.category = 'Clothing'
) b ON a.customer_id = b.customer_id
INNER JOIN Customers c ON c.customer_id = a.customer_id
WHERE b.customer_id IS NULL;

-- SECTION 4: WINDOW FUNCTIONS

-- Task 9: Rank products by price within each category.

SELECT category, product_name, price,
       RANK() OVER (
           PARTITION BY category
           ORDER BY price DESC
       ) AS price_rank
FROM Products;

-- Task 10: Display the previous product price and a running total

SELECT product_id, product_name, price,
       LAG(price) OVER (ORDER BY product_id) AS previous_price,
       SUM(price) OVER (ORDER BY product_id) AS running_total
FROM Products;

-- SECTION 5: CTES

-- Task 11: Create a CTE to display customers whose total purchase

WITH customer_totals AS (
    SELECT c.customer_id, c.customer_name,
           SUM(p.price * o.quantity) AS total_purchase
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Products p ON o.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_purchase
FROM customer_totals
WHERE total_purchase > (
    SELECT AVG(total_purchase)
    FROM customer_totals
);

-- Task 12: Create a recursive CTE to generate numbers from 1 to 10.

WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT n
FROM numbers;

-- SECTION 6: VIEWS

-- Task 13: Create a view for products priced above ₹1,000

CREATE OR REPLACE VIEW premium_products AS
SELECT product_id, product_name, category, price
FROM Products
WHERE price > 1000;

SELECT * FROM premium_products;

-- SECTION 7: INDEXES & PERFORMANCE

-- Task 14: Create an index on the category column of Products.

CREATE INDEX idx_products_category
ON Products(category);

-- Task 15: Use EXPLAIN to analyze a query that filters

EXPLAIN
SELECT product_id, product_name, price
FROM Products
WHERE category = 'Electronics';

-- SECTION 8: STORED PROCEDURES & FUNCTIONS

-- Task 16: Create a stored procedure to retrieve products by category.

DELIMITER //

CREATE PROCEDURE GetProductsByCategory(
    IN category_name VARCHAR(50)
)
BEGIN
    SELECT
        product_id,
        product_name,
        category,
        price
    FROM Products
    WHERE category = category_name;
END //

DELIMITER ;

CALL GetProductsByCategory('Electronics');

-- Task 17: Create a function to calculate the total price

DELIMITER //

CREATE FUNCTION GetOrderTotal(
    product_price DECIMAL(10,2),
    quantity INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
RETURN product_price * quantity //

DELIMITER ;

SELECT GetOrderTotal(55000, 2);

-- SECTION 9: TRANSACTIONS

-- Task 18: Update a product price and demonstrate COMMIT.

START TRANSACTION;

UPDATE Products
SET price = 56000
WHERE product_id = 1;

COMMIT;

SELECT product_name, price
FROM Products
WHERE product_id = 1;

-- Task 18: Demonstrate ROLLBACK.

START TRANSACTION;

UPDATE Products
SET price = 60000
WHERE product_id = 1;

ROLLBACK;

SELECT product_name, price
FROM Products
WHERE product_id = 1;

-- SECTION 10: TRIGGERS

-- Task 19: Create an audit table for new orders.

CREATE TABLE Order_Audit (
    order_id INT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE
);

-- Task 19: Create a trigger that records new orders

DELIMITER //

CREATE TRIGGER after_order_insert
AFTER INSERT ON Orders
FOR EACH ROW
INSERT INTO Order_Audit
VALUES (
    NEW.order_id,
    NEW.customer_id,
    NEW.product_id,
    NEW.quantity,
    NEW.order_date
) //

DELIMITER ;

-- Task 19: Test the trigger.

INSERT INTO Orders
VALUES (21, 5, 1, 1, '2024-09-01');

SELECT * FROM Order_Audit;

-- SECTION 11: PERFORMANCE TUNING

-- Task 20: Original query.

SELECT DISTINCT *
FROM Products
WHERE YEAR(created_date) = 2024
AND category = 'Electronics';

-- Task 20: Improved query.

SELECT product_id, product_name, category, price
FROM Products
WHERE created_date >= '2024-01-01'
AND created_date < '2025-01-01'
AND category = 'Electronics';
