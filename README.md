# SQL Advanced Assignment

## Assignment Overview

This assignment demonstrates advanced SQL concepts using an online shopping database. It covers joins, subqueries, set operations, window functions, CTEs, database objects, transactions, triggers, and query optimization.

## Database Schema

The database contains the following tables:

- **Customers** – stores customer details such as customer ID, name, city, and email.
- **Products** – stores product details such as product ID, name, category, price, and created date.
- **Orders** – stores order details and connects customers with the products they ordered.
- **Order_Audit** – stores details of newly inserted orders for auditing.

## Steps to Execute the SQL Script

1. Install and start MySQL.
2. Open MySQL Command Line or MySQL Workbench.
3. Create the required database and select it using `USE database_name;`.
4. Run the table creation and insert statements from the SQL script.
5. Execute the assignment queries section by section.
6. Run the view, index, procedure, function, transaction, and trigger commands.
7. Check the output of each query to verify the results.

## Advanced SQL Concepts Implemented

- Advanced Joins and CROSS JOIN
- Subqueries and Correlated Subqueries
- UNION and MySQL alternatives for INTERSECT and EXCEPT
- Window Functions using `RANK()` and `LAG()`
- Common Table Expressions (CTE)
- Recursive CTE
- Views
- Indexes and `EXPLAIN`
- Stored Procedures
- User-Defined Functions
- Transactions using `COMMIT` and `ROLLBACK`
- Triggers and Audit Table
- Query Optimization
