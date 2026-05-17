/*
Problem:
Table: Views

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| article_id    | int     |
| author_id     | int     |
| viewer_id     | int     |
| view_date     | date    |
+---------------+---------+
This table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write a solution to find all the people who viewed more than one article on the same date.

Return the result table sorted by id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
| 3          | 4         | 5         | 2019-08-01 |
| 1          | 3         | 6         | 2019-08-02 |
| 2          | 7         | 7         | 2019-08-01 |
| 2          | 7         | 6         | 2019-08-02 |
| 4          | 7         | 1         | 2019-07-22 |
| 3          | 4         | 4         | 2019-07-21 |
| 3          | 4         | 4         | 2019-07-21 |
+------------+-----------+-----------+------------+
Output: 
+------+
| id   |
+------+
| 5    |
| 6    |
+------+
*/
/*
Source: Leetcode 1149 - https://leetcode.com/problems/article-views-ii/description/
*/
/* Difficulty: Medium */
/* Topic: Sliding window, ROWS BETWEEN */
/*
Approach:
1. SELECT viewer_id AS id
2. We want COUNT of DISTINCT articles read by SAME viewer on the SAME day. So, to get entries with same viewer_id and view_date, we GROUP the entries by viewer_id and view_date.
3. After this grouping, we only want viewer_ids where the COUNT of DISTINCT article_ids is greater than 1.
4. Lastly, ORDER BY viewer_id as demanded by the problem.
*/
SELECT viewer_id AS id
FROM Views
GROUP BY viewer_id, view_date
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY viewer_id;

-- This solution failed a test case and it outputed viewer_id 13 twice
/* Adding DISTINCT after SELECT fixed the issue. The 13 appeared twice because there were 2 different days where user with viewer_id 13 read 2 or more distinct articles. By using SELECT DISTINCT, that issue is fixed*/

SELECT DISTINCT viewer_id AS id
FROM Views
GROUP BY viewer_id, view_date
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY viewer_id;

/*
What I learned / mistakes made:
1. Using multiple columns in GROUP BY
2. Problem had sliding window as the topic and I didn't use it. I don't know how window functions can be used to solve this problem.
*/