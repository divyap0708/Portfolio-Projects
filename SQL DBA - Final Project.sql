/*
Question 1.
Bubs wants you to track information on his customers (first name, last name, email), his employees (first name, 
last name, start date, position held), his products, and the purchases customers make (which customer, when it 
was purchased, for how much money). Think about how many tables you should create. Which data goes in which tables? 
How should the tables relate to one another?
*/

-- 4 tables:
-- Customer table (customer_id, first_name, last_name, email)
-- Employee table (employee_id, first_name, last_name, start_date, position_held)
-- Inventory (product_id, product_name)
-- Purchases (customer_purchase_id, customer_id, product_id, purchased_at, amount_usd)



/*
Question 2.
Given the database design you came up with, use Workbench to create an ERR diagram of the database. Include things 
like primary keys and foreign keys, and anything else you think you should have in the tables. Make sure to use 
reasonable data types for each column.
*/

-- Created as 'EER Final Project'



/*
Question 3.
Create a schema called bubsbooties. Within that schema, create the tables that you have diagramed out. Make sure 
they relate to each other, and that they have the same reasonable data types you selected previously.
*/

-- created schema and 4 tables using UI. Added foreign keys as well.



/*
Question 4.
Add any constraints you think your tables' column should have.
Think through which columns need to be unique, which are allowed to have NULL values, etc.
*/





/*
Question 5.
Insert at least 3 records of data into each table. The exact values do not matter,
so feel free to make them up. Just make sure that the data you insert amkes sense,
and that the tables tie together.
*/

USE bubsbooties;

SELECT * FROM customers;

INSERT INTO customers VALUES 
(1, 'Kathleen', 'McPauler', 'xyz@abc.com'),
(2, 'Landon', 'Oliver', 'abc@xyz.com'),
(3, 'Ella', 'Grace', 'def@abc.gov');

SELECT * FROM employees;

INSERT INTO employees VALUES 
(1, 'Tucker', 'Clover', 'manager', '2019-06-01'),
(2, 'Reily', 'Clover', 'cashier', '2019-09-01'),
(3, 'Brody', 'Clover', 'salesman', '2019-07-01');

SELECT * FROM products;

INSERT INTO products VALUES 
(1, 'Big Booties', '2019-09-01'),
(2, 'Medium Booties', '2019-09-01'),
(3, 'Mini Booties', '2019-09-01');

SELECT * FROM customer_purchases;

INSERT INTO customer_purchases VALUES 
(1, 1, 3, 2, '2019-09-05', 15.99),
(2, 2, 2, 3, '2019-09-07', 24.99),
(3, 3, 1, 1, '2019-09-12', 30.99);


/*
Question 6.
Create two users and give them access to the database.
The first user, TuckerReily, will be the DBA, and should get full database administrator privileges.
The second user, EllaBrody, is an Analyst, and only needs read access.
*/

-- Went to Asministration tab and created users
