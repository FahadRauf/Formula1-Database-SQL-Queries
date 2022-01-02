-- 1. How many drivers competed in 2016

select count(distinct r.driverId) as drivers
from results r
join races on races.raceId = r.raceId
where races.year = 2016



-- 2. Names of the drivers who competed in 2004 and did not compete in 2003

select distinct d.driverid,d.forename,d.surname,ra.year from drivers d
        join results r 
         on d.driverid = r.driverid 
         join races ra on r.raceid = ra.raceid 
         where ra.year = 2004 and 
         d.driverid not in 
                  (select d.driverid from drivers d
                 join results r 
                 on d.driverid = r.driverid 
                 join races ra on r.raceid = ra.raceid 
                 where ra.year = 2003)
order by d.driverid



-- 3. Names of the drivers who finished top 3 in 1996 and finished last 5 in 1999


with t_1996 as (select d.driverid, d.forename,d.surname 
from drivers d 
join results r 
on r.driverid = d.driverid
join races on races.raceid = r.raceid 
where year = 1996 
and position <=3)
, 
t_1999 as (
select d.driverid, d.forename,d.surname,r.raceid,position,year, count(d.driverid) over(partition by r.raceid) as numofpeople
from drivers d 
join results r 
on r.driverid = d.driverid
join races 
on r.raceid = races.raceid 
where year = 1999
),
last as(select * from t_1999
where (numofpeople - position <=4 or position = "")
)
select forename,surname from t_1996
where driverid in (select driverid from last)



