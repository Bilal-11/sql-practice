/*
Problem:
Table: Employee

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
 

Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.
*/
/*
Source: Leetcode 184 - https://leetcode.com/problems/department-highest-salary/description/
*/
/* Difficulty: Medium */
/* Topic: JOIN + subquery / window function  */
/*
Approach:
1. Firstly, Employee is LEFT JOINed with Department, to get department name and salaries in the same table, to determine highest salary departmentwise.
2. Next, we write a recursive query on the above join-table, then add RANK to this table partitioned by departement and ordered by salary desc. Call this table2.
3. Finally, select from table2 department, employee and salary, where RANK = 1. This should also handle cases where multiple employees have the same max salary as RANK should be 1 for all of them.

*/

WITH S AS (WITH R AS (SELECT Employee.name AS emp, Employee.salary, Department.name AS dept
FROM Employee
JOIN Department ON Employee.departmentId = Department.id)
SELECT emp, salary, dept, RANK() OVER(PARTITION BY dept ORDER BY salary DESC) AS deptrank
FROM R)
SELECT dept AS Department, emp AS Employee, salary AS Salary
FROM S
WHERE deptrank = 1;

/*
What I learned / mistakes made:
1. Why use Window functions: running totals, comparision between rows, ranking rows, top N per group, calculations that depends on values in other rows.
A qualitative answer I found was: Perform calculations that require context, with the "window" being the context. window = subset of rows
*/