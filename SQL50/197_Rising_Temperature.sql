/*
Problem:
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
*/
/*
Source: Leetcode 197 - https://leetcode.com/problems/rising-temperature/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Easy */
/* Topic: Joins */
/*
Approach:
1. We need to compare the temperature of a day with the temperature of the previous day. Both details are in the same table. We can place the two temperatures side by side for comparision using a self-join.
2. We self-JOIN Weather ON w1.id = w2.id + 1. w1 and w2 are both aliases for Weather table. w1 is used for current temperature and w2 for previous day's temperature.
3. Finally we filter rows WHERE w1.temperature > w2.temperature (current day temp > previous day temp).
*/

SELECT w1.id
FROM Weather w1
JOIN Weather w2 ON w1.id = w2.id + 1
WHERE w1.temperature > w2.temperature;

/*
Wrong Answer
8 / 15 testcases passed

Input
Weather =
| id | recordDate | temperature |
| -- | ---------- | ----------- |
| 1  | 2000-12-16 | 3           |
| 2  | 2000-12-15 | -1          |

Use Testcase
Output
| id |
| -- |
Expected
| Id |
| -- |
| 1  |

The assumption that id1 < id2 => recordDate1 < recordDate2 is false and renders the solution wrong.
*/

SELECT w1.id
FROM Weather w1
JOIN Weather w2 ON w1.recordDate = DATE_ADD(w2.recordDate,INTERVAL 1 DAY)
WHERE w1.temperature > w2.temperature;

--This ensures the 1 day difference regardless of ids

/*
What I learned / mistakes made:
1. The question stated "Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday)." all dates' with higher temperature than previous dates (yesterday). The comparision was between the dates NOT the ids. Therefore, read question carefully.
2. DATE_ADD
*/