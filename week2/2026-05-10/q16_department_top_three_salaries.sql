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
departmentId is a foreign key (reference column) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of a department and its name.
 

A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write a solution to find the employees who are high earners in each of the departments.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
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
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
Explanation: 
In the IT department:
- Max earns the highest unique salary
- Both Randy and Joe earn the second-highest unique salary
- Will earns the third-highest unique salary

In the Sales department:
- Henry earns the highest salary
- Sam earns the second-highest salary
- There is no third-highest salary as there are only two employees
*/
/*
Source: Leetcode 184 - https://leetcode.com/problems/department-top-three-salaries/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Hard */
/* Topic:  */
/*
Approach:
1. Join Employee and Department table on departmentId, SELECT Employee name, salary and Department name (Table1)
2. Select all columns from Table1 and add a RANK column PARTITION BY department ORDER BY salary DESC, call this RANK deptrank (Table2)
3. Select Employee, Salary, Department from Table2 WHERE deptrank = 1 OR 2 OR 3 (top 3 salaries)
*/

WITH S AS (WITH R AS (SELECT Employee.name AS emp, Employee.salary, Department.name AS dept
FROM Employee
JOIN Department ON Employee.departmentId = Department.id)
SELECT emp, salary, dept, RANK() OVER(PARTITION BY dept ORDER BY salary DESC) AS deptrank
FROM R)
SELECT dept AS Department, emp AS Employee, salary AS Salary
FROM S
WHERE deptrank = 1 OR deptrank = 2 OR deptrank = 3;

--Wrong output:
/*
Output
| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |

Expected
| Department | Employee | Salary |
| ---------- | -------- | ------ |
| IT         | Joe      | 85000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
*/

--Corrected Solution:
WITH S AS (WITH R AS (SELECT Employee.name AS emp, Employee.salary, Department.name AS dept
FROM Employee
JOIN Department ON Employee.departmentId = Department.id)
SELECT emp, salary, dept, DENSE_RANK() OVER(PARTITION BY dept ORDER BY salary DESC) AS deptrank
FROM R)
SELECT dept AS Department, emp AS Employee, salary AS Salary
FROM S
WHERE deptrank = 1 OR deptrank = 2 OR deptrank = 3;

/*
What I learned / mistakes made:
1. I thought using RANK would suffice, as it gives the same rank to the same values. So two employees with the same second-highest salaries would be accounted for.
What I didn't take into account is that after assigning rank 2 to two records, RANK will assign 4 as the rank to the thired-highest salary.
The correct function to use was DENSE_RANK, as it not only assigns same rank to same values, but also keeps the rank consecutive, so third highest salary wud still get rank 3 even if 2 people got the same second highest salary.
2. the condition in where clause can be WHERE deptrank <= 3 instead of WHERE deptrank = 1 OR deptrank = 2 OR deptrank = 3.
*/