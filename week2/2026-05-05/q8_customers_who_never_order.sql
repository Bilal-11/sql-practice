/*
Problem:
Table: Customers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID and name of a customer.
 

Table: Orders

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
customerId is a foreign key (reference columns) of the ID from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
 

Write a solution to find all customers who never order anything.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
Output: 
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
*/
/*
Source: Leetcode 183 - https://leetcode.com/problems/customers-who-never-order/description/
*/
/* Difficulty: Easy */
/* Topic: LEFT JOIN with NULL filter (or NOT IN) */
/*
Approach:
1. JOIN the two tables on customer id. The join will be a LEFT join because we want customers in table 1 NOT present in table2.
2. We can either use WHERE clause to get Customers.id NOT IN Orders.customerId, or
3. We can check WHERE the Orders.id IS NULL.
*/

SELECT Customers.name AS Customers
FROM Customers
LEFT JOIN Orders ON Customers.id = Orders.customerId
WHERE Customers.id NOT IN (SELECT customerId FROM Orders);

SELECT Customers.name AS Customers
FROM Customers
LEFT JOIN Orders ON Customers.id = Orders.customerId
WHERE Orders.id IS NULL;

/*
What I learned / mistakes made:
1. How to find the absence of something in the case of a JOIN, 2 ways of doing so (IS NULL, NOT IN).
2. In the ON clause of the LEFT JOIN, I mistyped Orders.cutomerId as Orders.id.

*/