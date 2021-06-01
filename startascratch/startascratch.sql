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


/*
Popularity Percentage
Find the popularity percentage for each user on Facebook. The popularity percentage is defined as the total number of friends 
the user has divided by the total number of users on the platform, then converted into a percentage by multiplying by 100.
Output each user along with their popularity percentage. Order records in ascending order by user id.
The 'user1' and 'user2' column are pairs of friends.
*/
with temp2 as 
(select * from facebook_friends
union
select user2, user1 from facebook_friends),
temp1 as(
select user1 from facebook_friends
union
select user2 from facebook_friends
),
temp3 as
(select t2.user1, count(user2) as co
from temp2 t2
group by t2.user1)
select t3.user1, (cast(t3.co as float)/count(temp1.user1))*100 as percentage
from temp3 t3, temp1
group by t3.user1, t3.co
order by t3.user1

/*
Highest Energy Consumption
Find the date with the highest total energy consumption from the Facebook data centers. 
Output the date along with the total energy consumption across all data centers.
*/
with temp as 
(select * from fb_asia_energy asia
union
select * from fb_na_energy na
union
select * from fb_eu_energy eu),
temp2 as 
(select date, sum(temp.consumption) as sumation
from temp
group by date)
select t2.date, sumation
from temp2 t2
where t2.sumation = (select max(sumation) from temp2)

/*
Popularity of Hack
Facebook has developed a new programing language called Hack.To measure the popularity of Hack they ran a survey with their employees. 
The survey included data on previous programing familiarity as well as the number of years of experience, age, gender and most importantly 
satisfaction with Hack. Due to an error location data was not collected, but your supervisor demands a report showing average popularity of Hack 
by office location. Luckily the user IDs of employees completing the surveys were stored.
Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.
*/
select emp.location, avg(hack.popularity) as average
from facebook_employees emp
join facebook_hack_survey hack
on emp.id = hack.employee_id
group by emp.location;

