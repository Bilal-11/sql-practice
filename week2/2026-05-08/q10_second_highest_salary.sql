/*
Problem:
Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |
+---------------------+
*/
/*
Source: Leetcode 176 - https://leetcode.com/problems/second-highest-salary/description/
*/
/* Difficulty: Medium */
/* Topic: : Subquery + handling NULL when no second-highest exists */
/*
Approach:
1. Find the max salary using a query
2. Find max salary less than the max salary found in step 1 (highest salary less than the highest salary is the 2nd highest salary)
*/

SELECT MAX(salary) AS SecondHighestSalary
FROM Employee
WHERE salary < (SELECT MAX(salary) FROM Employee);

/*
What I learned / mistakes made:
1. I thought I had to do some case handling when there is only 1 distinct salary in the table to return null, but just running this query passed all test cases.
Maybe because in case of 1 distinct salary, there is no salary less than that number, so null is returned. Thus no specific handling for that case.
*/