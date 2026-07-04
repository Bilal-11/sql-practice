/*
Problem:
Table: Transactions

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| country       | varchar |
| state         | enum    |
| amount        | int     |
| trans_date    | date    |
+---------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].
 

Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.

Return the result table in any order.

The query result format is in the following example.

 

Example 1:

Input: 
Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 121  | US      | approved | 1000   | 2018-12-18 |
| 122  | US      | declined | 2000   | 2018-12-19 |
| 123  | US      | approved | 2000   | 2019-01-01 |
| 124  | DE      | approved | 2000   | 2019-01-07 |
+------+---------+----------+--------+------------+
Output: 
+----------+---------+-------------+----------------+--------------------+-----------------------+
| month    | country | trans_count | approved_count | trans_total_amount | approved_total_amount |
+----------+---------+-------------+----------------+--------------------+-----------------------+
| 2018-12  | US      | 2           | 1              | 3000               | 1000                  |
| 2019-01  | US      | 1           | 1              | 2000               | 2000                  |
| 2019-01  | DE      | 1           | 1              | 2000               | 2000                  |
+----------+---------+-------------+----------------+--------------------+-----------------------+
*/
/*
Source: Leetcode 1193 - https://leetcode.com/problems/monthly-transactions-i/description/
*/
/* Difficulty: Medium */
/* Topic: Conditional Aggregation */
/*
Approach:
1. To get state and amount for each country for each month, we will GROUP BY trans_date and country
2. To get count of approve transactions and their total amounts, we use conditional aggregation, conditioned on action = 'approved used with COUNT and SUM.
3. To get count of transactions and their total amounts, we use simple aggregation.
*/

SELECT MONTH(trans_date) as month, country, COUNT(country) AS trans_count,COUNT(state = 'approved') AS approved_count, SUM(amount) AS trans_total_amount, SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY MONTH(trans_date), country;

-- COUNT(state = 'approved') gives the wrong count. Also month in wrong format

-- Corrected solution:
# Write your MySQL query statement below
SELECT DATE_FORMAT(trans_date,'%Y-%m') as month, country, COUNT(id) AS trans_count,COUNT(CASE WHEN state = 'approved' THEN 1 ELSE NULL END) AS approved_count, SUM(amount) AS trans_total_amount, SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date,'%Y-%m'), country;

/*
What I learned / mistakes made:
1. DATE_FORMAT(<date>,<format-specifier>) can be used to get dates in different formats.
2. COUNT(state='approved) doesn't work. COUNT(CASE WHEN state = 'approved' THEN 1 ELSE NULL END) does.
3. When counting values, non-null columns are more reliable. To get transaction_count, I initially used COUNT(country) which works but failed a test case where country was null. Thus, COUNT(id) is better in this case.
*/