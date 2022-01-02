# Formula1-Database-SQL-Queries

Analyzing the open source data on formula 1 races by applying advanced sql concepts

List of tables 
1. Races
2. Drivers
3. Results 

Q 1. How many drivers competed in 2016?

```SQL
SELECT COUNT(DISTINCT r.driverId) as drivers
FROM results r
JOIN races
  ON races.raceId = r.raceId
WHERE races.year = 2016
```

Q 2. Names of the drivers who competed in 2004 and did not compete in 2003

```SQL
SELECT DISTINCT d.driverid,d.forename,d.surname,ra.year 
FROM drivers d
JOIN results r
  on d.driverid = r.driverid
JOIN races ra 
  ON r.raceid = ra.raceid
WHERE ra.year = 2004 
  AND d.driverid not in 
  (SELECT d.driverid 
    FROM drivers d
    JOIN results r
      ON d.driverid = r.driverid
    JOIN races ra 
      ON r.raceid = ra.raceid
   WHERE ra.year = 2003)
ORDER BY d.driverid
```

Q 3. Names of the drivers who finished top 3 in 1996 and finished last 5 in 1999

```SQL
WITH t_1996 AS (
        SELECT d.driverid, d.forename,d.surname 
        FROM drivers d 
        JOIN results r 
            ON r.driverid = d.driverid
        JOIN races on races.raceid = r.raceid 
        WHERE year = 1996 
            AND position <=3
), 
t_1999 AS (
        SELECT d.driverid, d.forename,d.surname,r.raceid,position,year, COUNT(d.driverid) OVER (PARTITION by r.raceid) AS numofpeople
        FROM drivers d 
        JOIN results r 
            ON r.driverid = d.driverid
        JOIN races 
            ON r.raceid = races.raceid 
        WHERE year = 1999
),
LAST AS (
        SELECT * FROM t_1999
        WHERE (numofpeople - position <=4 OR position = "")
)
SELECT forename,surname 
FROM t_1996
WHERE driverid IN (SELECT driverid FROM last)
```


