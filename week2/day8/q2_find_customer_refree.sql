/*
Problem:
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| referee_id  | int     |
+-------------+---------+
In SQL, id is the primary key column for this table.
Each row of this table indicates the id of a customer, their name, and the id of the customer who referred them.
 

Find the names of the customer that are either:

referred by any customer with id != 2.
not referred by any customer.
Return the result table in any order.

The result format is in the following example.
Example 1:

Input: 
Customer table:
+----+------+------------+
| id | name | referee_id |
+----+------+------------+
| 1  | Will | null       |
| 2  | Jane | null       |
| 3  | Alex | 2          |
| 4  | Bill | null       |
| 5  | Zack | 1          |
| 6  | Mark | 2          |
+----+------+------------+
Output: 
+------+
| name |
+------+
| Will |
| Jane |
| Bill |
| Zack |
+------+
*/
/*
Source: Leetcode: 584 https://leetcode.com/problems/find-customer-referee/description/
*/
/* Difficulty: Easy */
/* Topic: NULL handling in WHERE */
/*
Approach:
1. SELECT the name column FROM Customer table
2. In output, rows where refree id is not 2 OR they are null are selected. So, use WHERE clause and combine these conditions with OR
*/

SELECT name
FROM Customer
WHERE referee_id !=2 OR referee_id IS NULL;

/*
What I learned / mistakes made:
1. AND and OR operator exclude NULL in its output. Special care needs to be taken in such cases.
*/