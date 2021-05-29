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

