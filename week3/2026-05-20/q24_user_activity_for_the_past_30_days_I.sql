/*
Problem:
Table: Activity

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| user_id       | int     |
| session_id    | int     |
| activity_date | date    |
| activity_type | enum    |
+---------------+---------+
This table may have duplicate rows.
The activity_type column is an ENUM (category) of type ('open_session', 'end_session', 'scroll_down', 'send_message').
The table shows the user activities for a social media website. 
Note that each session belongs to exactly one user.
 

Write a solution to find the daily active user count for a period of 30 days ending 2019-07-27 inclusively. A user was active on someday if they made at least one activity on that day.

Return the result table in any order.

The result format is in the following example.

Note: Any activity from ('open_session', 'end_session', 'scroll_down', 'send_message') will be considered valid activity for a user to be considered active on a day.

 

Example 1:

Input: 
Activity table:
+---------+------------+---------------+---------------+
| user_id | session_id | activity_date | activity_type |
+---------+------------+---------------+---------------+
| 1       | 1          | 2019-07-20    | open_session  |
| 1       | 1          | 2019-07-20    | scroll_down   |
| 1       | 1          | 2019-07-20    | end_session   |
| 2       | 4          | 2019-07-20    | open_session  |
| 2       | 4          | 2019-07-21    | send_message  |
| 2       | 4          | 2019-07-21    | end_session   |
| 3       | 2          | 2019-07-21    | open_session  |
| 3       | 2          | 2019-07-21    | send_message  |
| 3       | 2          | 2019-07-21    | end_session   |
| 4       | 3          | 2019-06-25    | open_session  |
| 4       | 3          | 2019-06-25    | end_session   |
+---------+------------+---------------+---------------+
Output: 
+------------+--------------+ 
| day        | active_users |
+------------+--------------+ 
| 2019-07-20 | 2            |
| 2019-07-21 | 2            |
+------------+--------------+ 
Explanation: Note that we do not care about days with zero active users.
*/
/*
Source: Leetcode 1141 - https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/
*/
/* Difficulty: Easy */
/* Topic: Time-bound aggregation */
/*
Approach:
1. For the condition that we are only interested in user activity in the 30 days before (and including) 2019-07-27. For this we filter rows in WHERE clause using activity_date BETWEEN DATE_SUB(2019-07-27, INTERVAL 30 DAY) AND 2019-07-27
2. We only care about user_id and activity_date columns here.
3. We COUNT DISTINCT user_ids and GROUP the entries by activity_date
*/

SELECT activity_date AS day, COUNT(DISTINCT(user_id)) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 30 DAY) AND '2019-07-27'
GROUP BY activity_date;

-- Failed a test case where entry with date 2019-06-27 shouldn't be there but was there. Corrected answer:

SELECT activity_date AS day, COUNT(DISTINCT(user_id)) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE_SUB('2019-07-27', INTERVAL 29 DAY) AND '2019-07-27'
GROUP BY activity_date;

/*
What I learned / mistakes made:
1. Past 30 days including the end date would mean that in DATE_SUB, I should use INTERVAL 29 DAY and not 30 DAY. Days counting error.
*/