# ⛐ Vehicle Accident Analysis

## 📝 Case Description
Analyze a dataset of vehicle accidents to understand their characteristics and identify potential patterns. That aims to leverage the power of SQL to answer critical questions about accident trends and contributing factors. By analyzing vehicle accidents with SQL, we can gain valuable insights into their patterns and contributing factors. This information can be used to develop effective safety interventions, improve infrastructure, and ultimately reduce the number and severity of accidents on the road.

##  📁 Data Set
- Accident [Databases](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Vehicle%20Accident%20Analysis/accident.csv)
- Vehicle [Databases](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Vehicle%20Accident%20Analysis/vehicle.csv)

## 🔧 Tools
Microsoft SQL Server 2022 for data analysis - View [SQL Scripts](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Vehicle%20Accident%20Analysis/Vehicle%20Accident%20Analysis.sql)

## 💡 Solution

### 1. How many accidents have occurred in urban areas versus rural areas?

````SQL
SELECT
	Area,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	accident
GROUP BY
	Area
````

### 2. Which day of the week has the highest number of accidents?

````SQL
SELECT
	Day,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	accident
GROUP BY
	Day
ORDER BY
	'Total Accidents' DESC
````

### 3. What is the average age of vehicles involved in accidents based on their type?

````SQL
SELECT
	VehicleType,
	COUNT(AccidentIndex) AS 'Total Accidents',
	AVG(AgeVehicle) AS 'Average Year'
FROM
	vehicle
WHERE
	AgeVehicle IS NOT NULL
GROUP BY
	VehicleType
ORDER BY
	'Total Accidents' DESC
````

###  4. Can we identify any trends in accidents based on the age of vehicles involved?

````SQL
SELECT
	AgeGroup,
	COUNT(AccidentIndex) AS 'Total Accidents',
	AVG(AgeVehicle) AS 'Average Year'
FROM (
	SELECT
		AccidentIndex,
		AgeVehicle,
		CASE
			WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'New'
			WHEN AgeVehicle BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS 'AgeGroup'
	FROM
		vehicle
) AS subquery
GROUP BY
	AgeGroup
````

### 5. Are there any specific weather conditions that contribute to severe accidents?

````SQL
DECLARE @Severity AS VARCHAR(100)
SET @Severity = 'Fatal'

SELECT
	WeatherConditions,
	COUNT(Severity) AS 'Total Accidents'
FROM
	accident
WHERE
	Severity = @Severity
GROUP BY
	WeatherConditions
ORDER BY
	'Total Accidents' DESC
````

### 6. Do accidents often involve impacts on the left-hand side of vehicles?

````SQL
SELECT
	LeftHand,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	vehicle
GROUP BY
	LeftHand
HAVING
	LeftHand IS NOT NULL
````

### 7. Is there any relationship between journey purposes and the severity of accidents?

````SQL
SELECT
	v.JourneyPurpose,
	a.Severity,
	COUNT(v.AccidentIndex) AS 'Total Accidents',
	CASE
		WHEN COUNT(v.AccidentIndex) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(v.AccidentIndex) BETWEEN 1001 AND 5000 THEN 'Moderate'
		ELSE 'High'
	END AS 'Level'
FROM
	vehicle AS v
JOIN
	accident AS a
	ON
	v.AccidentIndex = a.AccidentIndex
GROUP BY
	v.JourneyPurpose,
	a.Severity
ORDER BY
	2,
	3 DESC
````

### 8. Calculate the average age of vehicles involved in accidents, considering Day light and point of impact.

````SQL
DECLARE @Light VARCHAR(100)
DECLARE @Impact VARCHAR(100)

SET @Light = 'Daylight'
SET @Impact = 'Front'

SELECT
	a.LightConditions,
	v.PointImpact,
	AVG(v.AgeVehicle) AS 'Average Year'
FROM
	accident AS a
JOIN
	vehicle AS v
	ON
	a.AccidentIndex = v.AccidentIndex
GROUP BY
	a.LightConditions,
	v.PointImpact
HAVING
	a.LightConditions = @Light 
	AND 
	v.PointImpact = @Impact
````
