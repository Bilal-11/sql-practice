Day 3 — Aggregate Queries & Data Constraints
Q1. Why do we always use GROUP BY with aggregate functions? Can it be used without them?
Technically yes, you can use GROUP BY without an aggregate — but it's pointless. It just behaves like SELECT DISTINCT in that case.
The whole point of GROUP BY is to collapse multiple rows into one row per group. The only sensible thing to do with collapsed rows is summarize them — count them, sum them, average them. If you GROUP BY without aggregating, you've collapsed the rows but thrown away the information you collapsed.
SELECT department FROM employees GROUP BY department;
…is the same as…
SELECT DISTINCT department FROM employees;
The reverse is also worth knowing: aggregates without GROUP BY work fine — they just treat the whole table as one big group. SELECT AVG(salary) FROM employees returns one row.
Q2. Comparison: GROUP BY vs ORDER BY, and HAVING vs WHERE
This trips up everyone for the same reason — execution order. SQL doesn't run clauses in the order you write them.
Actual execution order:
FROM  →  WHERE  →  GROUP BY  →  HAVING  →  SELECT  →  ORDER BY
So WHERE happens before GROUP BY. That's why WHERE can't see aggregates like COUNT(*) — they don't exist yet. HAVING runs after GROUP BY, so it can.
Clause	Purpose	Operates on
WHERE	Filters rows	Individual rows, before grouping
GROUP BY	Collapses rows into groups	Rows
HAVING	Filters groups	Aggregated groups, after grouping
ORDER BY	Sorts the final result	Final output
Worked example combining all four:
SELECT department, COUNT(*) AS headcount
FROM employees
WHERE hire_date > '2020-01-01'        -- per-row filter
GROUP BY department
HAVING COUNT(*) > 5                    -- per-group filter
ORDER BY headcount DESC;
Quick rule: if your filter mentions an aggregate function, use HAVING. Otherwise use WHERE — it's faster because it filters before grouping (less data to group).
Q3. SELECT Employees.LastName — usage and limitations
That syntax is called a fully-qualified column reference: TableName.ColumnName.
Limitations? None really. It just gets verbose. You actually need it in two situations:
•	When two joined tables have columns with the same name (Orders.id vs Customers.id) — without the table qualifier, the database doesn't know which one you mean. It throws an 'ambiguous column' error.
•	For readability when reading a query that touches several tables — you can immediately see where each column comes from.
To avoid the verbosity, use table aliases. This is the cleaner industry style:
SELECT e.LastName, d.DeptName
FROM Employees e
JOIN Departments d ON e.DeptID = d.ID;
Q4. Is DELETE without WHERE the same as TRUNCATE? Is TRUNCATE more efficient?
End result is the same — you get an empty table. Mechanically they're very different operations, and the differences matter in interviews.
	DELETE (no WHERE)	TRUNCATE
How it works	Removes rows one by one	Deallocates whole pages
Speed	Slow on big tables	Near-instant
Logging	Each row logged (so it can be rolled back inside a transaction)	Minimally logged
Triggers	Fires DELETE triggers per row	Doesn't fire any triggers
Auto-increment	Keeps current value (next insert continues)	Resets to seed (next insert starts from 1)
Foreign keys	Works even if other tables FK-reference this one	Fails if other tables have FKs pointing to this table
So: yes, TRUNCATE is much faster for emptying a whole table. But it's not a drop-in replacement — if other tables reference yours via foreign keys, TRUNCATE will refuse. Use DELETE in that case.
Q5. Checking my understanding of HAVING syntax
Without seeing what specifically tripped you up on W3Schools, here's the canonical form. If something in this differs from what you wrote, that's the gap:
SELECT col, AGG(...)
FROM table
WHERE row_filter             -- optional
GROUP BY col
HAVING AGG(...) op value      -- the aggregate condition
ORDER BY ...;                 -- optional
One thing W3Schools doesn't emphasize enough: HAVING can technically reference any column from GROUP BY (not just aggregates). So HAVING department = 'Sales' is legal. But it's a code smell — that filter belongs in WHERE for performance. Use HAVING only when you genuinely need the aggregate.
Q6. If Table A has a foreign key referencing Table B, and I delete records from B — error or not?
Depends on the FK's ON DELETE rule. This is exactly the kind of question interviewers like, so know all four:
ON DELETE rule	What happens when you delete from B
NO ACTION / RESTRICT (default)	Error. Database refuses the delete because A still references that row.
CASCADE	Successful — and the matching rows in A are also deleted automatically.
SET NULL	Successful — A's foreign key column is set to NULL.
SET DEFAULT	Successful — A's foreign key is set to its DEFAULT value.
If you don't define a rule when creating the FK, most databases default to NO ACTION → error. That's why most production schemas explicitly choose CASCADE or SET NULL based on what they want.
Day 4 — Join Queries
Q7. SELECT Orders.OrderID, Customers.CustomerName … INNER JOIN Customers — do I still need to mention the table in FROM if I use Table.Col in SELECT?
You're thinking about it backwards. The FROM clause declares which tables exist in the query's scope. The SELECT clause uses those tables — it doesn't summon them.
So:
•	FROM Orders INNER JOIN Customers means: 'these two tables are in play'.
•	SELECT Orders.OrderID, Customers.CustomerName means: 'from those two tables, give me these specific columns'.
If you removed Customers from the JOIN, you couldn't reference Customers.CustomerName in SELECT — the table wouldn't be in scope. The qualifier 'Customers.' isn't bringing the table into the query; it's just disambiguating between tables that are already there.
The mental model: FROM = which tables. SELECT = which columns from those tables. WHERE/JOIN ON = how those tables connect.
Q8. Inner join between 3 tables — review
Same pattern as 2-table join, just chained. Each JOIN ... ON ... adds one more table to the query's scope.
SELECT o.OrderID, c.CustomerName, p.ProductName
FROM Orders o
INNER JOIN Customers c   ON o.CustomerID = c.CustomerID
INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
INNER JOIN Products p    ON oi.ProductID = p.ProductID;
Read top-to-bottom: 'Start with Orders. Connect Customers via CustomerID. Connect OrderItems via OrderID. Connect Products via ProductID.' Each line attaches one new table to the accumulating result.
The order in which you write the joins doesn't affect correctness — the query optimizer reorders them internally for performance. Write them in the order that's most readable to you.
Day 5 — Subqueries & Advanced Functions
Q9. SELECT * FROM CUSTOMERS WHERE ID IN (SELECT ID FROM CUSTOMERS WHERE SALARY > 4500) — can't we just write SELECT * FROM CUSTOMERS WHERE SALARY > 4500?
Yes. Exactly. That subquery is completely redundant. You spotted a bad textbook example.
The subquery and the simple version produce the same result with the same data. The subquery is doing extra work for no reason.
Subqueries are useful when you're filtering one table based on data from a different table or a different aggregation. Like these:
Useful subquery — filter using an aggregate from the same table:
SELECT * FROM CUSTOMERS
WHERE SALARY > (SELECT AVG(SALARY) FROM CUSTOMERS);
Useful subquery — filter one table using IDs from another:
SELECT * FROM CUSTOMERS
WHERE ID IN (SELECT customer_id FROM Orders WHERE order_date > '2026-03-01');
Important note: the fact that you caught this bad example means you're actually thinking about queries, not just memorizing patterns. That's exactly what we want. Most people just type the query without questioning it.
Q10. UPDATE CUSTOMERS … WHERE AGE IN (SELECT AGE FROM CUSTOMERS_BKP WHERE AGE >= 27) — same redundancy if tables are identical?
If CUSTOMERS and CUSTOMERS_BKP are truly identical (same rows, same data), then yes — same redundancy. You could just write WHERE AGE >= 27 directly.
But the textbook is hinting at a more realistic scenario where they're not identical. CUSTOMERS_BKP might be a snapshot from last year, or a subset (only premium customers). In that case, the subquery makes sense — you're using one table's data to filter another.
Real-world version: 'Update salaries for customers whose age also appears in our archive of premium customers.' That's not redundant — the two tables have genuinely different data.
Lesson: the subquery itself isn't wrong. The textbook just gave you identical tables, which makes the example look pointless. In real schemas, those two tables would have different rows.
Q11. INSERT INTO CUSTOMERS_BKP SELECT * FROM CUSTOMERS WHERE ID IN (SELECT ID FROM CUSTOMERS) — is this a nested subquery?
Three things going on here, let me unpack each:
1. Is the inner SELECT a subquery?
Yes. Any SELECT inside another query is a subquery.
2. Is it a nested subquery?
Technically yes (a subquery within a query qualifies). But the term 'nested subquery' usually implies multiple levels deep — a subquery inside a subquery inside the main query. So in everyday usage, this would just be called 'a query with a subquery,' not 'a nested subquery.'
3. Is this example useful at all?
No. The inner query 'SELECT ID FROM CUSTOMERS' returns every customer ID. So 'WHERE ID IN (every ID)' is the same as no filter at all. The whole statement is just 'INSERT all customers from CUSTOMERS into CUSTOMERS_BKP.' Another bad textbook example. You're right to find it suspicious.
A real nested subquery looks like this — three levels deep, each level filtering the next:
SELECT * FROM employees
WHERE department_id IN (
  SELECT id FROM departments
  WHERE region_id IN (
    SELECT id FROM regions WHERE country = 'India'
  )
);
Q12. ROUND(number, decimals, operation) — what does operation do?
This is a MySQL/MariaDB-specific quirk and almost never used in practice. Don't waste energy memorizing it.
The third argument controls rounding direction:
•	0 (or omitted): round half away from zero — standard rounding. ROUND(2.5) = 3.
•	Non-zero: truncate toward zero. ROUND(2.7, 0, 1) = 2.
In most other SQL dialects (PostgreSQL, SQL Server, Oracle), ROUND only takes two arguments. If you ever need truncation, use TRUNC() or FLOOR()/CEIL() — they're clearer and portable across databases. Skip the third argument unless you're specifically targeting MySQL.
Day 6 — Transactions
Q13. SET TRANSACTION
Command that configures properties for a transaction before any data changes happen. The most common thing you set is the isolation level (which is your next question).
Skeleton:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN;
  -- your queries here
COMMIT;
You can also set things like READ ONLY vs READ WRITE, and deferrable constraints — but for now, SET TRANSACTION = 'I'm configuring the next transaction's behavior.' That's enough.
Q14. SERIALIZABLE
The strictest of the four SQL isolation levels. Isolation levels control what concurrent transactions can see of each other while they run.
There are three 'anomalies' that can happen when transactions overlap. Each level prevents more of them:
Isolation Level	Dirty Read	Non-repeatable Read	Phantom Read
READ UNCOMMITTED	Possible	Possible	Possible
READ COMMITTED (default in most DBs)	Prevented	Possible	Possible
REPEATABLE READ	Prevented	Prevented	Possible
SERIALIZABLE	Prevented	Prevented	Prevented
The three anomalies, in plain English:
•	Dirty read — you read uncommitted data from another transaction. If they roll back, you've based decisions on data that never officially existed.
•	Non-repeatable read — you read the same row twice in your transaction and get different values, because someone else updated it between your reads.
•	Phantom read — you read the same set of rows twice and get different rows, because someone else inserted or deleted in between.
SERIALIZABLE prevents all three by making concurrent transactions behave as if they ran one after another. Cost: lower concurrency, more locking, slower throughput. You use it when correctness absolutely cannot be compromised — banking transfers, inventory deduction, anything where one wrong number is unacceptable.
For interview purposes, this is enough to say: 'READ COMMITTED is the default in most databases. SERIALIZABLE is when correctness matters more than speed.' That single sentence is more than 90% of candidates can articulate.

Two things I want you to do this week
1. Re-enter Day 4 onwards in the tracker. The timestamps and durations got mashed into single cells (the 1131314161.05 stuff). Either it was a paste issue or the columns slipped — fix it before Sunday so we can analyze cleanly.
2. Start producing SQL queries, not just reading about them. Every session in Week 1 had 'N/A' as the Output Artifact — that's fine for an overview week, but Week 2 must shift. The goal is solving problems on DataLemur, SQLZoo, or LeetCode, with each session producing 3–5 solved queries you save to a GitHub repo. The Week 2 planner I'll send next has the exact problems and sequencing.
Honestly, the quality of these confusion notes is the best signal you've given me so far. Most people don't even realize they're confused — they just nod along and forget. You're isolating the exact gaps. Keep doing this. The questions get sharper as the topics get deeper.
