/*
Problem:
Table: Employee

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| department  | varchar |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the name of an employee, their department, and the id of their manager.
If managerId is null, then the employee does not have a manager.
No employee will be the manager of themself.
 

Write a solution to find managers with at least five direct reports.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+-----+-------+------------+-----------+
| id  | name  | department | managerId |
+-----+-------+------------+-----------+
| 101 | John  | A          | null      |
| 102 | Dan   | A          | 101       |
| 103 | James | A          | 101       |
| 104 | Amy   | A          | 101       |
| 105 | Anne  | A          | 101       |
| 106 | Ron   | B          | 101       |
+-----+-------+------------+-----------+
Output: 
+------+
| name |
+------+
| John |
+------+

*/
/*
Source: Leetcode 570 - https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Medium */
/* Topic: Basic Joins */
/*
Approach:
1. This is a case of self join on managerId = id.
2. 
*/

SELECT B.name
FROM Employee AS A
LEFT JOIN Employee AS B
ON A.managerId = B.id
GROUP BY B.id,B.name
HAVING COUNT(B.id) >= 5;

/*
What I learned / mistakes made:
1. For atleast I forgot to use >= instead of > .
2. For conditions on aggregate functions, I made the mistake of using WHERE instead of HAVING.
3. I failed a Test case where there were two Johns with different ids and at least 5 direct reports. This made me realise the importance of table ids, I had to select the name, but the HAVING clause wud be on the COUNT of id, not name.
4. Multiple columns can be used in GROUP BY.
5. I corrected my mistake mentioned in point 3 above, and had both name and id in the GROUP BY clause. In hindsight, only id was required.
6. In my original solution, I also wrote a clause WHERE B.name IS NOT NULL, which was unnecessary as aggregate functions ignore null values (except COUNT(*)) and also lead to me failing a testcase where no manage had atleast 5 reports.
*/