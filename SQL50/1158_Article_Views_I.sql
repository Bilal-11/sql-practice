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
There is no primary key (column with unique values) for this table, the table may have duplicate rows.
Each row of this table indicates that some viewer viewed an article (written by some author) on some date. 
Note that equal author_id and viewer_id indicate the same person.
 

Write a solution to find all the authors that viewed at least one of their own articles.

Return the result table sorted by id in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Views table:
+------------+-----------+-----------+------------+
| article_id | author_id | viewer_id | view_date  |
+------------+-----------+-----------+------------+
| 1          | 3         | 5         | 2019-08-01 |
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
| 4    |
| 7    |
+------+
*/
/*
Source: Leetcode 1158 - https://leetcode.com/problems/article-views-i/description/?envType=study-plan-v2&envId=top-sql-50
*/
/* Difficulty: Easy */
/*
Approach:
1. We have to get distinct records where author_id and viewer_id match
2. And arrange the ids in ascending order. article_id and view_date are irrelevant here.
*/

SELECT DISTINCT author_id AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY id;

/*
What I learned / mistakes made:
1. Note that the alias 'id' can be used in ORDER BY but not the WHERE clause because of execution order: FWG-HSO (From Where Group BY - Having Select Order BY)
*/