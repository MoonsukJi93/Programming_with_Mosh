-- YouTube: https://www.youtube.com/watch?v=7S_tz1z_5bA


-- The SELECT statment--
--

-- How to retrieve data from a single table
USE sql_store; -- best practice: capitalize SQL keywords

-- SELECT (column) FROM (table)
-- select all customers in a given table
SELECT * 
FROM customers;
-- WHERE customer_id = 1 -- filter results
-- ORDER BY first_name -- columns we want to sort on
-- line breaks and tabs are ignored in SQL


-- The SELECT clause --
--

SELECT 
	last_name, 
    first_name, 
    points, 
    -- multiplication and division has higher presedence over addition and subtraction
    (points + 10) * 100 AS 'discount factor' -- alias to each column in the result set
FROM customers

SELECT DISTINCT state
FROM customers;

-- Exercise
-- Return all the products
   -- name
   -- unit price
   -- new price (unit price * 1.1)

SELECT name, unit_price, unit_price * 1.1 AS new_price
FROM products;


-- The WHERE Clause --
--

SELECT * -- iterate all the customers in the Customers table
FROM Customers
WHERE points > 3000; -- if this condition is TRUE
-- >, >=, <, <=, =
-- not equal operators: !=, <>

SELECT *
FROM Customers
WHERE state <> 'va'; -- get the same result when we type state = 'VA'

SELECT *
FROM Customers
WHERE birth_date > '1990-01-01'; -- default format for representing date in MySQL ();

-- Exercise
-- Get the orders placed this year (assuming this year is 2019) 
SELECT *
FROM orders
WHERE order_date >= '2019-01-01';


-- The AND, OR, and NOT Operators
--

-- Combine multiple search conditions when filtering data:
SELECT *
FROM Customers
WHERE birth_date > '1990-01-01' AND points > 1000; -- satisfy both of these conditions

SELECT *
FROM Customers
WHERE birth_date > '1990-01-01' OR points > 1000; -- satisfy at least one of these conditions

SELECT *
FROM Customers
WHERE birth_date > '1990-01-01' OR
	  (points > 1000 AND state = 'VA');
-- 1) AND (always evaluated first b/c it has higher precedence)
-- 2) OR

-- NOT: negate a condition
SELECT *
FROM Customers
WHERE NOT (birth_date > '1990-01-01' OR points > 1000);
-- WHERE (birth_date <= '1990-01-01' AND points <= 1000);

-- Exercise
-- From the order_items table, get the items
-- 		   for order #6
-- 		   where the total price is greater than 30'

SELECT *
FROM order_items
WHERE order_id = 6 AND unit_price * quantity > 30; -- we can use arithmetic expressions in a WHERE clause

-- The IN Operator
-- Use it when you want to compare an attribute to a list of values

SELECT *
FROM Customers
WHERE state IN ('VA', 'FL', 'GA');
-- SQL can't combine string with a boolean expression that produces a boolean value
-- WHERE state = 'VA' OR state = 'GA' OR state = 'FL';

SELECT *
FROM Customers
WHERE state NOT IN ('VA', 'FL', 'GA');

-- Exercise
-- Return products with
--    quantity in stock equal to 49, 38, 72
SELECT *
FROM products 
WHERE quantity_in_stock IN (49, 38, 72);

-- The BETWEEN Operator
--

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000; -- range values are inclusive
-- WHERE points >= 1000 AND points <= 3000;

-- Exercise
-- Return customers born
--                  between 1/1/1990 and 1/1/2000

SELECT *
FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01';

-- The LIKE Operator
-- Retrieve rows that match a specific string pattern

SELECT *
FROM customers
-- WHERE last_name LIKE 'b%'; -- (case-insensitive)
-- WHERE last_name LIKE 'brush%';
-- WHERE last_name LIKE '%b%'; -- (any number of characters before or after b)
-- WHERE last_name LIKE '%y'; -- last name ends with y
-- WHERE last_name LIKE '_y' -- 2 characters long ending with y
-- WHERE last_name LIKE '_____y';
WHERE last_name LIKE 'b____y';
-- % any number of characters
-- _ single character

-- Exercise
-- Get the customers whose
--    addresses contain TRAIL or AVENUE
SELECT *
FROM customers
WHERE address LIKE '%TRAIL%' OR
	  address LIKE '%AVENUE%';
-- phone numbers end with '%9';
SELECT *
FROM customers
WHERE phone LIKE '%9';
-- phone numbers don't end with '%9';
SELECT *
FROM customers
WHERE phone NOT LIKE '%9';


-- The REGEXP Operator
--

SELECT *
FROM customers
-- WHERE last_name LIKE '%field%'
-- WHERE last_name REGEXP 'field' -- allow us to search for more complex patterns
-- WHERE last_name REGEXP '^field'
-- ^: indicate beginning of the string
-- WHERE last_name REGEXP 'field$' -- last name must end with field.
-- $: represent the end of the string
-- WHERE last_name REGEXP 'field|mac'; -- last name that has the words 'field' or 'mac'
-- WHERE last_name REGEXP 'field|mac|rose';
-- |: represents multiple search patterns
-- WHERE last_name REGEXP '^field|mac|rose'
-- WHERE last_name REGEXP 'field$|mac|rose'
-- WHERE last_name REGEXP '[gim]e' -- 'ge' or 'ie' or 'me' in last name
-- WHERE last_name REGEXP 'e[fmq]' -- 'ef' or 'em' or 'eq' in last name
WHERE last_name REGEXP '[a-h]e'; -- from 'ae' to 'he'

-- ^ beginning
-- $ end
-- | logical or
-- [abcd]
-- [a-f]

-- Exercise
-- Get the customers whose
--    first names are ELKA or AMBUR
SELECT *
FROM customers
WHERE first_name REGEXP 'ELKA|AMBUR';
--    last names end with EY or ON
SELECT *
FROM customers
WHERE last_name REGEXP 'EY$|ON$';
--    last names start with MY or contains SE
SELECT *
FROM customers
WHERE last_name REGEXP '^MY|SE';
--    last names contain B followed by R or U
SELECT *
FROM customers
WHERE last_name REGEXP 'B[RU]';

-- The IS NULL Operator
-- Look for records that miss an attribute

-- NULL = absense of a value.
SELECT *
FROM customers
-- WHERE phone IS NULL; -- every customer that does not have a phone number
WHERE phone IS NOT NULL; -- every customer that has a phone number

-- Exercise
-- Get the orders that are not shipped
SELECT *
FROM orders
WHERE shipped_date IS NULL;
-- WHERE shipper_id IS NULL;


-- The ORDER BY Clause
-- Sort data in your SQL queries

SELECT *
FROM customers
-- ORDER BY first_name; -- sorted by first name in ascending order (ASC)
-- ORDER BY first_name DESC;
-- ORDER BY state, first_name;
ORDER BY state DESC, first_name DESC;
-- primary key: values in column uniquely identify each column
-- In MySQL, you can sort data by any columns whether that column is in the 
-- SELECT clause or not.

SELECT first_name, last_name
FROM customers
ORDER BY birth_date;

SELECT first_name, last_name, 10 AS points -- 'points' is an alias
FROM customers
ORDER BY points, first_name; -- valid query from MySQL's point of view

-- sort customers by first name and last name
SELECT first_name, last_name, 10 AS points
FROM customers
ORDER BY 1, 2; -- 1, 2: order of these columns (first_name, last_name)
-- sorting data by column results produces unexpected results (something you should avoid)
-- so, sort by column names

-- Exercise
SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

-- The LIMIT Clause
-- How to limit the number of records from your queries
SELECT *
FROM customers
-- LIMIT 3; -- return on the first 3 customers
-- LIMIT 300; -- get all the 10 customers even though we don't have 300 customers

-- page 1: 1 - 3
-- page 2: 4 - 6
-- page 3: 7 - 9
LIMIT  6, 3; -- offset that tell MySQL to skip the first 6 records and then pick 3 records

-- Exercise
-- Get the top three loyal customers
SELECT *
FROM customers
ORDER BY points DESC
LIMIT 3; -- LIMIT clause should always come at the end!

-- Inner Joins
-- Select/join columns from multiple tables

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o
JOIN customers c -- 'INNER' keyword is optional
	ON o.customer_id = c.customer_id;

-- Exercise
SELECT order_id, oi.product_id, quantity, oi.unit_price
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id;
-- p.unit_price: current price right now
-- oi.unit_price: price at the time the customer places an order


-- Joining Across Databases
-- Combine columns from tables across multiple databases

USE sql_inventory;
-- Only have to prefix the tables that are not part of the current database.
-- In other words, your query will be different depending on the database.

SELECT *
FROM sql_store.order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;

-- Self Joins
-- Join a table with itself (use different alias and prefixes for each column)
USE sql_hr;

SELECT
	e.employee_id,
    e.first_name,
    m.first_name AS manageremployees
FROM employees e
JOIN employees m
	ON e.reports_to = m.employee_id

-- Joining Multiple Tables
-- Join more than two tables when writing a query.
USE sql_store;

SELECT 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
JOIN order_statuses os
	ON o.status = os.order_status_id;

-- Exercise
USE sql_invoicing;

SELECT
	p.date,
    p.invoice_id,
    p.amount,
    c.name,
    pm.name
FROM payments p
JOIN clients c
ON p.client_id = c.client_id
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id;

-- Compound Join Conditions
-- use single columns to uniquely identify rows in a given table
-- but there are times we can't use single columnscustomers
USE sql_store;

SELECT *
FROM order_items oi
JOIN order_item_notes oin
-- compound join condition: multiple conditions to join these two tables
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;


-- Implicit Join Syntax
--

-- Explicit Join Syntax
SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id;

-- Implicit Join Syntax
SELECT *
FROM orders o, customers c
WHERE o.customer_id = c.customer_id -- get cross-join if forgetting to type WHERE clause.
-- cross-join: every record in orders joined with every record in customers table

-- Outer Joins
--

-- INNER JOIN
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- OUTER JOIN
-- See all the customers whether they have an order or not.

-- LEFT JOIN
-- All the records from the left table (customers) are returned whether ON
-- condition is true or not.
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
LEFT OUTER JOIN orders o -- 'OUTER' keyword is optional.
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- RIGHT JOIN
-- All the records from the rigth table (orders) are returned whether ON
-- condition is true or not. The result below is same as INNER JOIN, so we
-- need to swap the order of the tables.
SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM customers c
RIGHT JOIN orders o
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

SELECT
	c.customer_id,
    c.first_name,
    o.order_id
FROM orders o
RIGHT OUTER JOIN customers c -- 'OUTER' keyword is optional.
	ON c.customer_id = o.customer_id
ORDER BY c.customer_id;

-- Exercise
SELECT
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id
ORDER BY p.product_id;

-- Outer Joins Between Multiple Tables
--

SELECT
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name AS shipper
FROM customers c
LEFT JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
ORDER BY c.customer_id;

-- Exercise
SELECT
	o.order_date,
	o.order_id,
    c.first_name AS customer,
    sh.name AS shipper,
    os.name AS status
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
LEFT JOIN shippers sh
	ON sh.shipper_id = o.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY os.name;


-- Self Outer Joins
--

USE sql_hr;

SELECT
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
JOIN employees m -- only return people who have managers
	ON e.reports_to = m.employee_id

SELECT
	e.employee_id,
    e.first_name,
    m.first_name AS manager
FROM employees e
LEFT JOIN employees m -- get every employee in the table whether they have a manager or not
	ON e.reports_to = m.employee_id


-- The USING clause
--

USE sql_store;

SELECT
	o.order_id,
    c.first_name,
    sh.name AS shipper
FROM orders o
JOIN customers c
	-- ON o.customer_id = c.customer_id
    USING (customer_id)
LEFT JOIN shippers sh -- b/c some of our orders are not shipped
	USING (shipper_id);
-- If the column name is exactly the same across different tables,
-- replace the ON clause with the USIN clause which is simpler and shorter.

SELECT *
FROM order_items oi
JOIN order_item_notes oin
	USING (order_id, product_id);
--  ON oi.order_id = oin.order_id AND
--      oi.product_id = oin.product_id

-- Exercise
USE sql_invoicing;

SELECT
	p.date,
    c.name AS client, -- from clients table
    p.amount,
    pm.name AS payment_method -- from payment_methods table
FROM payments p
	JOIN clients c USING (client_id)
	JOIN payment_methods pm
		ON p.payment_method = pm.payment_method_id
ORDER BY pm.name DESC;


-- Natural Joins
-- Another simple way to join tables
USE sql_store;

SELECT
	o.order_id,
    c.first_name
FROM orders o
NATURAL JOIN customers c
-- Don't explicitly specify the column names. Database engine will join based on the 
-- common columns that don't have the same name.


-- Cross Joins
-- Combine or join every record from the first table to every record in the second table.

 -- explicit syntax
SELECT
	c.first_name AS cutomer,
    p.name AS product
FROM customers c -- implicit syntax: remove CROSS JOIN and uswe only FROM (+, products p)
CROSS JOIN products p
ORDER BY c.first_name;
-- Real example: When you have a table of all sizes (small, medium, large) and all colors
-- (small, medium, large) and then you want to combine all the sizes with all
-- the columns.

-- implicit syntax
SELECT
	c.first_name AS cutomer,
    p.name AS product
FROM customers c, products p
ORDER BY c.first_name;

-- Exercise
--
USE sql_store;

-- Do a cross join between shippers and products
--    using the implicit syntax
SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh, products p
ORDER BY sh.name;

--    and the using the explicit syntax
SELECT
	sh.name AS shipper,
    p.name AS product
FROM shippers sh
CROSS JOIN products p
ORDER BY sh.name;


-- Unions
-- Combine rows from multiple tables

SELECT
	order_id,
    order_date,
    'Active' AS status
FROM orders
WHERE order_date >= '2019-01-01'
UNION -- combine records from multiple queries
SELECT
	order_id,
    order_date,
    'Archived' AS status
FROM orders
WHERE order_date < '2019-01-01';

-- the numbers of columns that each queries return should be equal.
SELECT name AS full_name
FROM shippers
UNION
SELECT first_name
FROM customers;

-- Exercise
SELECT
	customer_id,
    first_name,
    points,
    CASE
		WHEN points > 3000 THEN 'Gold'
		WHEN points < 3000 AND points >= 2000 THEN 'Silver'
		WHEN points < 2000 THEN 'Bronze'
	END AS type
FROM customers
ORDER BY first_name;

SELECT
	customer_id,
    first_name,
    points,
    'Bronze' AS type
FROM customers
WHERE points < 2000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Silver' AS type
FROM customers
WHERE points BETWEEN 2000 AND 3000
UNION
SELECT
	customer_id,
    first_name,
    points,
    'Gold' AS type
FROM customers
WHERE points > 3000
ORDER BY first_name;


-- Column Attributes
-- insert, update, and delete data


-- Inserting a Single Row
-- Insert a row into a table

INSERT INTO customers (
	first_name,
    last_name,
    birth_date,
    address,
    city,
    state)
-- VALUES (200) -- supply values for every column in this table
-- AI (Auto Increment): MySQL will generate a unique value for the customer_id (DEFAULT)
VALUES (
    'Smith',
    'John',
    '1190-01-01',
    'address',
    'city',
    'CA');

-- Inserting Multiple Rows
--

INSERT INTO shippers (name)
VALUES ('Shipper1'),
	   ('Shipper2'),
       ('Shipper3');

-- Exercise
-- Insert three rows in the products table
INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('Product1', 10, 1.95),
	   ('Product2', 11, 1.95),
	   ('Product3', 12, 1.95);

-- Inserting Hierarchical Rows
-- Insert data into multiple tables.

-- parent child relationships: one row in the orders table can have one or more
-- children inside the order_items table.

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-02', 1);

-- Return the id that MySQL generates when we insert a new row.
-- SELECT LAST_INSERT_ID()

INSERT INTO order_items
VALUES 
	(LAST_INSERT_ID(), 1, 1, 2.95),
    (LAST_INSERT_ID(), 2, 1, 3.95)


-- Creating a Copy of a Table
-- Copy data from one table to another
CREATE TABLE orders_archived AS 
SELECT * FROM orders; -- subquery: SELECT statement that is part of another SQL statement

-- deleted all data by tuncating the table

INSERT INTO orders_archived
SELECT *
FROM orders
WHERE order_date < '2019-01-01';

-- Exercise
-- 
USE sql_invoicing;

CREATE TABLE invoices_archived AS
SELECT
	i.invoice_id,
    i.number,
    c.name AS client,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.payment_date,
    i.due_date
FROM invoices i
JOIN clients c 
	USING (client_id)
WHERE payment_date IS NOT NULL;

-- Updating a Single Row
-- 
USE sql_invoicing;

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE invoice_id = 3;


-- Updating Multiple Rows
-- 
UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id = 3; 
-- WHERE client_id IN (3, 4); 

-- Exercise
-- Write a SQL statement to
--    give any customers born before 1990
--    50 extra points

USE sql_store;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01';

-- Using Subqueries in Updates
--
USE sql_invoicing;

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE client_id IN
			(SELECT client_id
			FROM clients
			WHERE state IN ('CA', 'NY'));

UPDATE invoices
SET
	payment_total = invoice_total * 0.5,
    payment_date = due_date
WHERE payment_date IS NULL;

-- Exercise
-- Update comments for orders for customers who have more than 3000 points ('Gold customer')
USE sql_store;

UPDATE orders
SET
	comments = 'Gold Customer'
WHERE customer_id IN 
	   (SELECT customer_id
		FROM customers
        WHERE points > 3000);


-- Deleting Rows
--
USE sql_invoicing;

DELETE FROM invoices
WHERE client_id = (
	SELECT client_id
	FROM clients
	WHERE name = 'Myworks'
);


-- Restoring Course Databases
--
