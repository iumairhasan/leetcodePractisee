/*
Premium vs Freemium
Find the total number of downloads for paying and non-paying users by date. 
Include only records where non-paying customers have more downloads than paying customers.
The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads.
All required columns and the first 5 rows of the solution are shown
date	non_paying	paying
2020-08-16	15	14
2020-08-17	45	9
2020-08-18	10	7
2020-08-21	32	17

*/

with temp as
(
select df.date, sum(df.downloads) as downloads, ad.paying_customer
from ms_user_dimension u
left join ms_acc_dimension ad
on u.acc_id = ad.acc_id
left join ms_download_facts df
on u.user_id = df.user_id
group by df.date, ad.paying_customer
order by date asc
)
select  * 
from (select date, sum(case when paying_customer = 'no' then downloads end) as non_paying, sum(case when paying_customer = 'yes' then downloads end) as paying
from temp group by date) t
where t.non_paying > t.paying
order by t.date

/*
Salaries Differences
Write a query that calculates the difference between the highest salaries found in the marketing and engineering departments. Output just the difference in salaries.
Tables: db_employee, db_dept*/
with temp as 
(select department_id, max(e.salary)
from db_employee e
group by e.department_id)
select (select max from temp where department_id = 4) - (select max from temp where department_id = 1)


/*
Finding Updated Records
We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information.
Find the current salary of each employee assuming that salaries increase each year. Output their id, first name, last name, department ID, 
and current salary. Order your list by employee ID in ascending order.
*/
select id, first_name, last_name, department_id, max(salary) as current_salary
from ms_employee_salary
group by id, first_name, last_name, department_id
order by id;

/*
Top Search Results
You're given a table that contains search results. If the 'position' column represents the position of the search results,
write a query to calculate the percentage of search results that were in the top 3 position.
*/
select (cast ((select count(position) from fb_search_results where position < 4) as float)/(select count(position) from fb_search_results) * 100) as top_3_percentage;

/*
Acceptance Rate By Date
What is the overall friend acceptance rate by date? Your output should have the rate of acceptances by the date the request was sent. Order by the earliest date to latest.

Assume that each friend request starts by a user sending (i.e., user_id_sender) a friend request to another user (i.e., user_id_receiver) that's logged in the table with
 action = 'sent'. If the request is accepted, the table logs action = 'accepted'. If the request is not accepted, no record of action = 'accepted' is logged.
*/

select f1.date, cast(count(f2.user_id_sender) as float)/count(f1.user_id_sender)
from 
    (select * from fb_friend_requests where action = 'sent') f1
    left join (select * from fb_friend_requests where action = 'accepted') f2
    on (f1.user_id_sender = f2.user_id_sender) and (f1.user_id_receiver = f2.user_id_receiver)
group by f1.date
order by f1.date

