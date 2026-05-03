/*
Problem:
Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 
 

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+
Output: 
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+
Explanation: 
Average selling price = Total Price of Product / Number of products sold.
Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96
*/
/*
Source: LeetCode 1251 - https://leetcode.com/problems/average-selling-price/description/
*/
/* Difficulty: Easy */
/* Topic: JOIN + GROUP BY + aggregate calculation */
/*
Approach:
1. 
I wanted to get a product_id, price, units table to see how to go about calculating the average:

SELECT Prices.product_id, Prices.price, UnitsSold.units
FROM Prices
LEFT JOIN UnitsSold
ON Prices.product_id = UnitsSold.product_id AND (UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date)

Output
| product_id | price | units |
| ---------- | ----- | ----- |
| 1          | 5     | 100   |
| 1          | 20    | 15    |
| 2          | 15    | 200   |
| 2          | 30    | 30    |

2. Finding the product of price and units and adding it to the above table:

(SELECT Prices.product_id, Prices.price, UnitsSold.units, Prices.price * UnitsSold.units AS Prod
FROM Prices
LEFT JOIN UnitsSold
ON Prices.product_id = UnitsSold.product_id AND (UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date)

| product_id | price | units | Prod |
| ---------- | ----- | ----- | ---- |
| 1          | 5     | 100   | 500  |
| 1          | 20    | 15    | 300  |
| 2          | 15    | 200   | 3000 |
| 2          | 30    | 30    | 900  |

3. Use this as a table for a recursive query to divide the sum of prod and the sum of units, then round it to 2 decimal places to get the average price.
For the 2 sums, GROUP BY on product_id.

# Write your MySQL query statement below
WITH R AS (SELECT Prices.product_id, Prices.price, UnitsSold.units, Prices.price * UnitsSold.units AS Prod
FROM Prices
LEFT JOIN UnitsSold
ON Prices.product_id = UnitsSold.product_id AND (UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date))

SELECT product_id, ROUND(SUM(Prod)/SUM(units),2) AS average_price
FROM R
GROUP BY product_id;

4. To deal with NULL values, use COALESCE to provide default average_price as 0 to get the final solution below:
*/

# Write your MySQL query statement below
WITH R AS (SELECT Prices.product_id, Prices.price, UnitsSold.units, Prices.price * UnitsSold.units AS Prod
FROM Prices
LEFT JOIN UnitsSold
ON Prices.product_id = UnitsSold.product_id AND (UnitsSold.purchase_date BETWEEN Prices.start_date AND Prices.end_date))

SELECT product_id, COALESCE(ROUND(SUM(Prod)/SUM(units),2),0) AS average_price
FROM R
GROUP BY product_id;

/*
What I learned / mistakes made:
1. Determining what kind of join to make and seeing the result of the join in your head
2. SQL arithmetic operators when they interact will NULL, they produce NULL.
3. COALESCE() function can be used to provide default values for expressions that may be NULL sometimes.
4. ROUND function rounds the decimal value. I forgot about the rounding part.
5. For a problem, the path to the final solution may not always be apparent at the start, but working towards intermediate outputs can pave the way to the final solution.
*/