/*
Problem:
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
This table may contain duplicates rows. 
customer_id is not NULL.
product_key is a foreign key (reference column) to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key (column with unique values) for this table.
 

Write a solution to report the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+
Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+
Output: 
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: 
The customers who bought all the products (5 and 6) are customers with IDs 1 and 3.
*/
/*
Source: Leetcode 1045 - https://leetcode.com/problems/customers-who-bought-all-products/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Medium */
/* Topic:  */
/*
Approach:
1. In the Customer table, there may be duplicate rows. To confirm if a customer bought all products, we don't care about multiple purchases of the same product by a customer. We only care about DISTINCT purchases of all the products in Products table.
So, first, SELECT DISTINCT rows from Customer table (Call it Table1).
2. SELECT customer_id FROM Table1, where the COUNT of a customer_id is equal to the COUNT of the product_ids in Products table,
implying that only customers that bought all products should be selected.
*/

WITH R AS (SELECT DISTINCT customer_id, product_key
FROM Customer)
SELECT customer_id
FROM R
WHERE COUNT(customer_id) = (
    SELECT COUNT(*)
    FROM Product
)
GROUP BY customer_id;
--> Invalid use of group function error

--Corrected Solution:
WITH R AS (SELECT DISTINCT customer_id, product_key
FROM Customer)
SELECT customer_id
FROM R
GROUP BY customer_id
HAVING COUNT(customer_id) = (
    SELECT COUNT(*)
    FROM Product
);

/*
What I learned / mistakes made:
1. I used WHERE (instead of HAVING) with aggregate functions which is not allowed.
*/