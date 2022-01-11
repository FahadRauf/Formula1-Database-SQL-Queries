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
INNER JOIN races
  ON races.raceId = r.raceId
WHERE races.year = 2016
```

Q 2. Names of the drivers who competed in 2004 and did not compete in 2003

```SQL
SELECT DISTINCT d.driverid,d.forename,d.surname,ra.year 
FROM drivers d
INNER JOIN results r
  on d.driverid = r.driverid
INNER JOIN races ra 
  ON r.raceid = ra.raceid
WHERE ra.year = 2004 
  AND d.driverid not in 
  (SELECT d.driverid 
    FROM drivers d
    INNER JOIN results r
      ON d.driverid = r.driverid
    INNER JOIN races ra 
      ON r.raceid = ra.raceid
   WHERE ra.year = 2003)
   ORDER BY d.driverid
```

Q 3. Names of the drivers who finished top 3 in 1996 and finished last 5 in 1999

```SQL
WITH t_1996 AS (
        SELECT d.driverid, d.forename,d.surname 
        FROM drivers d 
        INNER JOIN results r 
            ON r.driverid = d.driverid
        INNER JOIN races on races.raceid = r.raceid 
        WHERE year = 1996 
            AND position <=3
), 
t_1999 AS (
        SELECT d.driverid, d.forename,d.surname,r.raceid,position,year, COUNT(d.driverid) OVER (PARTITION BY r.raceid) AS numofpeople
        FROM drivers d 
        INNER JOIN results r 
            ON r.driverid = d.driverid
        INNER JOIN races 
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


Q. 4 Names of the people with fastest lap in each year, return driver name, year and race name

```SQL
WITH fastest AS (
    SELECT re.driverId, re.raceId, re.fastestlaptime, ra.year, ra.name, RANK() OVER (PARTITION BY ra.year ORDER BY re.fastestLapTime) AS ftestlap 
    FROM results re 
    INNER JOIN races ra 
       ON re.raceId = ra.raceId
    WHERE NOT fastestlaptime = ""
)
SELECT d.forename,d.surname,f.year,f.name 
FROM drivers d 
INNER JOIN fastest f 
    ON d.driverId = f.driverId
WHERE ftestlap = 1
```
