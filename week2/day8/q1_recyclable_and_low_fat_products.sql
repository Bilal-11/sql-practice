/*
Problem:
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| low_fats    | enum    |
| recyclable  | enum    |
+-------------+---------+
product_id is the primary key (column with unique values) for this table.
low_fats is an ENUM (category) of type ('Y', 'N') where 'Y' means this product is low fat and 'N' means it is not.
recyclable is an ENUM (category) of types ('Y', 'N') where 'Y' means this product is recyclable and 'N' means it is not.
 

Write a solution to find the ids of products that are both low fat and recyclable.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+-------------+----------+------------+
| product_id  | low_fats | recyclable |
+-------------+----------+------------+
| 0           | Y        | N          |
| 1           | Y        | Y          |
| 2           | N        | Y          |
| 3           | Y        | Y          |
| 4           | N        | N          |
+-------------+----------+------------+
Output: 
+-------------+
| product_id  |
+-------------+
| 1           |
| 3           |
+-------------+
Explanation: Only products 1 and 3 are both low fat and recyclable.
*/
/*
Source: Leetcode 1757 - https://leetcode.com/problems/recyclable-and-low-fat-products/description/
*/
/* Difficulty: Easy */
/* Topic: WHERE with multiple conditions */
/*
Approach:
1. In the output, product_id column is seen, so first I select it from the Products table
2. Then I need to apply a filter for lowfat and recyclable. So I use WHERE clause with AND operator to combine both the conditions.

*/

SELECT product_id
FROM Products
WHERE low_fats = 'Y' and recyclable = 'Y'

/*
What I learned / mistakes made: N/A
*/