/*
Problem:
Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

user_transactions Table:
Column Name	Type
product_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	123	68.90	07/08/2022 12:00:00
9623	123	274.10	07/08/2022 12:00:00
1467	115	19.90	07/08/2022 12:00:00
2513	159	25.00	07/08/2022 12:00:00
1452	159	74.50	07/10/2022 12:00:00
Example Output:
transaction_date	user_id	purchase_count
07/08/2022 12:00:00	115	1
07/08/2022 12:00:000	123	2
07/10/2022 12:00:00	159	1
The dataset you are querying against may have different input & output - this is just an example!
*/
/*
Source: DataLemur - https://datalemur.com/questions/histogram-users-purchases
*/
/* Difficulty: Medium */
/* Topic: Window Function */
/*
Approach:
1. 'Output user's most recent transaction date' - most recent transaction date = highest timestamp.
2. The rows corresponding to each user is a window and finding highest timestamp in the window -> Top N in group -> Window function
3. So we write CTE 'windowed' in which we use the window function MAX PARTITIONing it BY user_id and ORDERing it BY transaction_date in DESCending order (highest/latest timestamp at the top).
4. Right after the CTE windowed, we SELECT transaction_date, user_id and purchase_count (COUNT(user_id)) FROM windowed GROUP BY user_id, to get the purchase count.
*/

WITH windowed AS (
    SELECT user_id, MAX(transaction_date) OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS latest_td
    FROM user_transactions
)
SELECT latest_td AS transaction_date, user_id, COUNT(user_id) AS purchase_count
FROM windowed
GROUP BY user_id;

/*
Output

transaction_date	user_id	purchase_count
2022-07-12 10:00:00	115	    2
2022-07-11 10:00:00	123	    4
2022-07-12 10:00:00	159	    4

Expected

transaction_date	user_id	purchase_count
2022-07-11 10:00:00	123	    1
2022-07-12 10:00:00	115	    1
2022-07-12 10:00:00	159	    2
*/

-- Corrected solution (using hints from DataLemur):
WITH windowed AS (
    SELECT transaction_date, user_id, RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rk
    FROM user_transactions
)
SELECT transaction_date, user_id, COUNT(user_id) AS purchase_count
FROM windowed
WHERE rk = 1
GROUP BY user_id
ORDER BY transaction_date;

/*
What I learned / mistakes made:
1. Using RANK instead of MAX solved it. Why couldn't MAX solve it? MAX was giving me double the purchase count.
2. With MAX, ORDER BY is not needed.
3. In the query outside of CTE, an ORDER BY was needed to get all transactions from all users in increasing order of timestamps (I missed this part of the problem, need to read the problem carefully).
*/