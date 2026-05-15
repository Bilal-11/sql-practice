/*
Problem:
The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. In this SQL interview query for Data Analyst at Bloomberg, you're given the historical data on Google's stock performance.

Your task is to:

Calculate the difference in closing prices between consecutive months.
Calculate the difference between the closing price of the current month and the closing price from 3 months prior.
This question serves as a platform for you to explore into the dataset and execute your queries. Please refrain from submitting your solution for this question.

stock_prices Schema:
Column Name	Type	Description
date	datetime	The specified date (mm/dd/yyyy) of the stock data.
ticker	varchar	    The stock ticker symbol (e.g., AAPL) for the corresponding company.
open	decimal	    The opening price of the stock at the start of the trading day.
high	decimal	    The highest price reached by the stock during the trading day.
low	    decimal	    The lowest price reached by the stock during the trading day.
close	decimal	    The closing price of the stock at the end of the trading day.

stock_prices Example Input:

date	            ticker	open	high	low	close
01/31/2023 00:00:00	GOOG	89.83	101.58	85.57	99.87
02/28/2023 00:00:00	GOOG	99.74	108.82	88.86	90.30
03/31/2023 00:00:00	GOOG	90.16	107.51	89.77	104.00
04/30/2023 00:00:00	GOOG	102.67	109.63	102.38	108.22
05/31/2023 00:00:00	GOOG	107.72	127.05	104.50	123.37

*/
/*
Source: DataLemur - https://datalemur.com/questions/sql-bloomberg-stock-performance
*/
/* Difficulty: Hard */
/* Topic: LAG */

-- This question serves as a platform for you to explore into the dataset and execute your queries. Please refrain from submitting your solution for this question.

/*
Approach:
1. In a CTE, SELECT date, close, Then LAG(close) (we want monthy diff in closing price) ORDERed BY date and also LAG(close,3) (to help calculate difference between current closing price and closing price 3 months prior).
2. in the WHERE clause we only select entries where ticker = GOOG (we only want to calculate these closing price differences for Google)
3. Outside of CTE we SELECT date and do close-close1 and close-close3 to get the desired differences in closing price for Google.
*/

WITH lagged AS (
  SELECT date, close, LAG(close) OVER(ORDER BY date) AS close1, LAG(close,3) OVER(ORDER BY date) AS close3
  FROM stock_prices
  WHERE ticker = 'GOOG'
)
SELECT date, close-close1 AS monthly_diff, close-close3 AS three_month_diff
FROM lagged;

/*
What I learned / mistakes made:
1. Use of LAG and its counterpart LEAD to get rows behind/ahead of current row based on a column.
2. LAG and LEAD are useful for time-series analysis and help operate on data within the same table without using self-joins.
3. In hindsight, I should add an ORDER BY date in the outer query to make sure the data is presented chronologically.
*/

--For this question, DataLemur asked to refrain us from submitting the solution. So the input and output for this problem are in 2026-05-15 folder to verify the accuracy of the solution.

