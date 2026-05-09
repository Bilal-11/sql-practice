/*
Problem:
Table: Visits

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.
This table contains information about the customers who visited the mall.
 

Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
This table contains information about the transactions made during the visit_id.
 

Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Return the result table sorted in any order.

The result format is in the following example.

 

Example 1:

Input: 
Visits
+----------+-------------+
| visit_id | customer_id |
+----------+-------------+
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |
+----------+-------------+
Transactions
+----------------+----------+--------+
| transaction_id | visit_id | amount |
+----------------+----------+--------+
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
+----------------+----------+--------+
Output: 
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
Explanation: 
Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
Customer with id = 30 visited the mall once and did not make any transactions.
Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
Customer with id = 96 visited the mall once and did not make any transactions.
As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.
*/
/*
Source: Leetcode 1581 - https://leetcode.com/problems/customer-who-visited-but-did-not-make-any-transactions/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Easy */
/* Topic: Basic joins */
/*
Approach:
1. we join the Visits and Transactions tables on visit_id to get the visit_ids that made transactions.
2. Then we select customer_ids from Visits and their COUNTs (grouped by customer_id) where the visit_id is NOT IN the subquery in Step1 above.
*/

SELECT customer_id, COUNT(customer_id) AS count_no_trans
FROM Visits
WHERE visit_id NOT IN (SELECT Visits.visit_id
FROM Visits
JOIN Transactions ON Visits.visit_id = Transactions.visit_id)
GROUP BY customer_id;

/*
What I learned / mistakes made:
1. In this example, I made a mistake when using JOIN keyword. I thought it would do a left join, but by default it does an inner join. My initial approach was to use left-join Visits on Transactions and count the NULL rows for each customer_id.
2. visit_id 5 in Visits has multiple matches in visit_id in Transactions, so in an inner join, all 3 records with visit_id 5 will be shown, whereas if it was a left join, only 1 will be shown.
*/