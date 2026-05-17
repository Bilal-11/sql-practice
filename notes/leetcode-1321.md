# Restaurant Growth
I was unable to solve this problem. So, I want to take a closer look at solution from this problem and learn from it.

## Problem Statement
Table: Customer

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| visited_on    | date    |
| amount        | int     |
+---------------+---------+
In SQL,(customer_id, visited_on) is the primary key for this table.
This table contains data about customer transactions in a restaurant.
visited_on is the date on which the customer with ID (customer_id) has visited the restaurant.
amount is the total paid by a customer.
 

You are the restaurant owner and you want to analyze a possible expansion (there will be at least one customer every day).

Compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.

Return the result table ordered by visited_on in ascending order.

The result format is in the following example.

 

Example 1:

Input: 
Customer table:
```
+-------------+--------------+--------------+-------------+
| customer_id | name         | visited_on   | amount      |
+-------------+--------------+--------------+-------------+
| 1           | Jhon         | 2019-01-01   | 100         |
| 2           | Daniel       | 2019-01-02   | 110         |
| 3           | Jade         | 2019-01-03   | 120         |
| 4           | Khaled       | 2019-01-04   | 130         |
| 5           | Winston      | 2019-01-05   | 110         | 
| 6           | Elvis        | 2019-01-06   | 140         | 
| 7           | Anna         | 2019-01-07   | 150         |
| 8           | Maria        | 2019-01-08   | 80          |
| 9           | Jaze         | 2019-01-09   | 110         | 
| 1           | Jhon         | 2019-01-10   | 130         | 
| 3           | Jade         | 2019-01-10   | 150         | 
+-------------+--------------+--------------+-------------+
```
Output: 
```
+--------------+--------------+----------------+
| visited_on   | amount       | average_amount |
+--------------+--------------+----------------+
| 2019-01-07   | 860          | 122.86         |
| 2019-01-08   | 840          | 120            |
| 2019-01-09   | 840          | 120            |
| 2019-01-10   | 1000         | 142.86         |
+--------------+--------------+----------------+
```
Explanation: 
1st moving average from 2019-01-01 to 2019-01-07 has an average_amount of (100 + 110 + 120 + 130 + 110 + 140 + 150)/7 = 122.86
2nd moving average from 2019-01-02 to 2019-01-08 has an average_amount of (110 + 120 + 130 + 110 + 140 + 150 + 80)/7 = 120
3rd moving average from 2019-01-03 to 2019-01-09 has an average_amount of (120 + 130 + 110 + 140 + 150 + 80 + 110)/7 = 120
4th moving average from 2019-01-04 to 2019-01-10 has an average_amount of (130 + 110 + 140 + 150 + 80 + 110 + 130 + 150)/7 = 142.86

## My Failed Attempt
```sql
SELECT visited_on, SUM(amount) AS amount, AVG(amount) OVER(ROWS BETWEEN 6 PRECEDING AND CURRENT ROW ORDER BY visited_on) AS average_amount
FROM Customer
GROUP BY visited_on
ORDER BY visited_on
OFFSET 6;
```
> You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'ORDER BY visited_on) AS average_amount FROM Customer GROUP BY visited_on ORDER B' at line 2

## Sample Solution
```sql
SELECT DISTINCT visited_on, SUM(amount) OVER W AS amount, ROUND((SUM(amount) OVER W)/7,2) AS average_amount
FROM Customer
WINDOW W AS(
    ORDER BY visited_on
    RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
)
LIMIT 6,999;
```

## 🔍 A Closer look at the Sample Solution and mistakes in my solution
```
+-------------+--------------+
| visited_on   | amount      |
|--------------+-------------+
| 2019-01-01   | 100         |
| 2019-01-02   | 110         |
| 2019-01-03   | 120         |
| 2019-01-04   | 130         |
| 2019-01-05   | 110         | 
| 2019-01-06   | 140         | 
| 2019-01-07   | 150         |
| 2019-01-08   | 80          |
| 2019-01-09   | 110         | 
| 2019-01-10   | 130         | 
| 2019-01-10   | 150         | 
+--------------+-------------+
```
The sample data shows 2 entries for `2019-01-10`. So, I wanted to use `SUM` aggregate function `GROUP BY visited_on` to get only 1 summed up amount value for each day, no matter how many entries it had. Since `GROUP BY` is executed before `SELECT` I thought the aggregate `SUM` function would get executed first and the resulting table would contain only distinct `visited_on` values with their summed up amounts. Then, the window function `SUM` would operate on THAT summed up amount, i.e., I thought:

SELECT visited_on, SUM(amount) AS **amount**, AVG(**amount**) OVER(ROWS BETWEEN 6 PRECEDING AND CURRENT ROW ORDER BY visited_on) AS average_amount

are the same. Turns out, they are not. An alias used in the SELECT clause cannot be referred in the same SELECT clause. Thus my efforts to get the summed up amount for each day in the window function `SUM` didn't work.

The error I got in my solution was because I put `ORDER BY` after `ROWS BETWEEN`. If I put it before, then there was no error. This is because for terms like `PRECEDING` and `FOLLOWING` order must be specified beforehand.

Also, `OFFSET` cannot be used without `LIMIT`. In the Sample Solution:
```sql
LIMIT 6,999
```
is shorthand for:
```sql
LIMIT 999 OFFSET 6
```

In the same solution, I learn that a window can be defined separately using `WINDOW` keyword as:
```sql
WINDOW W AS (...)
```
and then used with `OVER` as `SUM(amount) OVER W`. Note that writing `OVER(W)` will result in an error as the parenthesis after `OVER` define a window, so writing `W` in those parenthesis is like putting a window in a window which doesn't make sense.

Focussing on the window definition in the Sample Solution:
```sql
WINDOW W AS(
    ORDER BY visited_on
    RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
)
```
Firstly, the entries are ordered by `visited_on` to ensure a chronological order of entries.

**ROWS vs RANGE**
`ROWS` is used to describe a window in terms of rows whereas `RANGE` is used to describe a window in terms of the **value** of the number/date by which the window is ordered by.

The Sample Solution defines the window as:
```sql
WINDOW W AS(
    ORDER BY visited_on
    RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
)
```
where it uses `RANGE` so that only the past 6 **days** in `visited_on` are considered for the `SUM` alongwith the current row. What this means is that even though `2019-01-10` had 2 entries, the window will include both entries when the current row is `2019-01-10` as it will include the current day and past 6 days. It will not just take the first amount value with `visited_on = 2019-01-10` and the last 6 rows as a window for `SUM` and leave the other amount value with `visited_on = 2019-01-10`.

Thus, what I was trying to do with aggregate function `SUM` can be easily achieved by setting a better window using `RANGE` instead of `ROWS`.

Finally, in the Sample Solution,
```sql
SELECT DISTINCT visited_on, SUM(amount) OVER W AS amount, ROUND((SUM(amount) OVER W)/7,2) AS average_amount
```
`SELECT DISTINCT` is used so that each `visited_on` date appears only once even if it has multiple entries. And to calculate the average the value returned by the `SUM` window function is divided by 7 and rounded to 2 decimal places.

Also, for the `average_amount` following will not give the right answer:
```sql
ROUND((AVG(amount) OVER W),2) AS average_amount
```
This is because the window `W` can contain more than 7 values if a day has more than one entries; and `AVG` window functin will count multiple entries as belonging to separate days, even though they belong to the same day. So `2019-01-10` has 2 entries. The above would take sum of those 2 entries and the past 6 days and divide it by **8** instead of 7 as there are 8 entries even if they belong to 7 days.

_Useful resource:_ https://learnsql.com/blog/range-clause/
