/*
Problem:
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
 

Write a solution to find the employees who earn more than their managers.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
Output: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
Explanation: Joe is the only employee who earns more than his manager.
*/
/*
Source: Leetcode 181 - https://leetcode.com/problems/employees-earning-more-than-their-managers/description/
*/
/* Difficulty: Easy */
/* Topic: Self Joins */
/*
Approach:
1. For each employee we have salary and manager, but not the manager's salary in the same row.
2. A self-join on manager id will put employee and manager salary in the same row for easy comparision and filtering.
*/

SELECT A.name AS Employee
FROM Employee as A
JOIN Employee AS B 
ON A.managerID = B.id AND A.salary > B.salary;

/*
What I learned / mistakes made:
1. Use case for self-join. It was a weird concept the first time I read about it.
2. Self-join syntax.
3. You can put conditions in the ON clause while doing a JOIN.
*/