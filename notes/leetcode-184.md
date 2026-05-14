# Department Highest Salary

I solved this problem 3 times: once using subqueries and twice using window functions. This file looks those approaches and what could have been done better.

## Problem Statement
Problem:
Table: Employee
```
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
```
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference columns) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department
```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
```
id is the primary key (column with unique values) for this table. It is guaranteed that department name is not NULL.
Each row of this table indicates the ID of a department and its name.
 

Write a solution to find employees who have the highest salary in each of the departments.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
```
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
```
Department table:
```
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
```
Output: 
```
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
```
Explanation: Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.


## Attempt1: Subqueries
_link to solution: https://github.com/Bilal-11/sql-practice/blob/main/week2/2026-05-05/q9_department_highest_salary.sql_
```sql
WITH R AS (SELECT Department.name AS Department, Employee.name AS Employee, Employee.salary AS Salary
From Employee
JOIN Department on Employee.departmentId = Department.id),
S AS(SELECT Department AS dept, MAX(Salary) AS sala
FROM R
GROUP BY Department)
SELECT Department, Employee, Salary
FROM R
JOIN S ON R.Department = S.dept AND R.Salary = S.sala
;
```

## Attempt2: Window Functions 1
_link to solution: https://github.com/Bilal-11/sql-practice/blob/main/week2/2026-05-10/q9_department_highest_salary_resolve.sql_
```sql
WITH S AS (WITH R AS (SELECT Employee.name AS emp, Employee.salary, Department.name AS dept
FROM Employee
JOIN Department ON Employee.departmentId = Department.id)
SELECT emp, salary, dept, RANK() OVER(PARTITION BY dept ORDER BY salary DESC) AS deptrank
FROM R)
SELECT dept AS Department, emp AS Employee, salary AS Salary
FROM S
WHERE deptrank = 1;
```

## Attempt3: Window Functions 2
_link to solution: https://github.com/Bilal-11/sql-practice/blob/main/week3/2026-05-14/q9_v3.sql_
```sql
WITH ranked AS (
    SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary, RANK() OVER(PARTITION BY e.departmentId ORDER BY e.salary DESC) AS rk
    FROM Employee e
    JOIN Department d ON e.departmentId = d.id
)
SELECT Department, Employee, Salary
FROM ranked
WHERE rk = 1;
```

## Comparision

[Attempt 1](#attempt1-subqueries) creates 2 tables: first joins Employee and Department (on departmentId) and second gets the highest salary departmentwise. The final query joins the first table with the second on matching department name and highest salary, thus only employees with highest salaries in their department will be selected.

This attempt did in 3 steps what could have been done in one step using a non-correlated subquery (thus it was bloating syntax and increasing execution time):
```sql
--Attempt 1 better
SELECT d.name AS Department, e.name AS Employee, e.salary AS Salary
FROM Employee e
JOIN Department d
WHERE (e.departmentId, e.salary) IN (
    SELECT deparmentId, MAX(salary) 
    FROM Employee 
    GROUP BY departmentId
);
```

[Attempt3](#attempt3-window-functions-2) is the cleaner usage of windows function compared to [Attempt2](#attempt2-window-functions-1), solving the problem in 4 lines and just one CTE in wrapper-filter format. Like Attempt1, Attempt2 does a 1 step job in 3 steps: joining tables, adding rank and filtering on rank; all of which Attempt 3 does in 1 step.

The lesson here is to not unnecessarily create subqueries for a job that can be done in 1 step while being readable. Secondly, for top-N problems, window functions are a very handy and efficient tool and thus should be utilised.