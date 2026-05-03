/*
Problem:
Table: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key (column with unique values) for this table.
This table contains information about the order ID and the customer ID.
 

Write a solution to find the customer_number for the customer who has placed the largest number of orders.

The test cases are generated so that exactly one customer will have placed more orders than any other customer.

The result format is in the following example.

 

Example 1:

Input: 
Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+
Output: 
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+
Explanation: 
The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
So the result is customer_number 3.

Follow up: What if more than one customer has the largest number of orders, can you find all the customer_number in this case?
*/
/*
Source: Leetcode 586 - https://leetcode.com/problems/customer-placing-the-largest-number-of-orders/description/
*/
/* Difficulty: Easy */
/* Topic: GROUP BY + ORDER BY + LIMIT */
/*
Approach:
0. SELECT customer_number FROM Orders table
1. To find the customer with highest number of orders, we count the number of orders each customer has placed. This is done my using COUNT with GROUP BY on customer_number
2. ORDER BY DESC to get the highest number on top
3. LIMIT 1 to get the customer with highest number of orders
4. Follow up Q: We can use RANK on customer_number ordered desc by count of customer_number
*/

SELECT customer_number
FROM Orders
GROUP BY customer_number
ORDER BY COUNT(customer_number) DESC LIMIT 1;

/*
What I learned / mistakes made:
1. You can use aggregate functions in ORDER BY clauses too, not necessarily in SELECT clauses. My initial attempt used it in the SELECT clause and the output had 1 extra count column which wasnt in the required output.
*/ 