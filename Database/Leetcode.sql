/*

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the primary key for this table.
This table contains information about the temperature in a certain day.
Write an SQL query to find all dates' id with higher temperature compared to its previous dates (yesterday).

Return the result table in any order.
Table: Weather

*/

/* Write your T-SQL query statement below */
select y.id 
from Weather w, weather y
where datediff(day, w.recordDate, y.recordDate) = 1 
	and (y.Temperature > w.Temperature)
/*
Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+

*/

# Write your MySQL query statement below
Delete t
from Person t, Person p
where t.Email = p.Email and t.Id > p.Id