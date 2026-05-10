/*
Problem:
x`Table: Triangle

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
| y           | int  |
| z           | int  |
+-------------+------+
In SQL, (x, y, z) is the primary key column for this table.
Each row of this table contains the lengths of three line segments.
 

Report for every three line segments whether they can form a triangle.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Triangle table:
+----+----+----+
| x  | y  | z  |
+----+----+----+
| 13 | 15 | 30 |
| 10 | 20 | 15 |
+----+----+----+
Output: 
+----+----+----+----------+
| x  | y  | z  | triangle |
+----+----+----+----------+
| 13 | 15 | 30 | No       |
| 10 | 20 | 15 | Yes      |
+----+----+----+----------+
*/
/*
Source: Leetcode 610 - https://leetcode.com/problems/triangle-judgement/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Easy */
/* Topic: case-when-then */
/*
Approach:
1. Can be solved by a simple CASE WHEN THEN expression, to see if any two side sum is equal to the third sid (triangle = yes in that case). Else its not a triangle.
*/

SELECT x, y, z, 
CASE
    WHEN x + y > z AND y + z > x AND x + z > y THEN 'Yes'
    ELSE 'No'
END AS triangle
FROM Triangle;

/*
What I learned / mistakes made:
1. CASE WHEN THEN in sql, similar to switch case in other languages.
*/