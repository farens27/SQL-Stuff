-- 1. How many accidents have occured in urban areas versus rural areas?
SELECT
	Area,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	accident
GROUP BY
	Area

-- 2. Which day of the week has the highest number of accidents?
SELECT
	Day,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	accident
GROUP BY
	Day
ORDER BY
	'Total Accidents' DESC

-- 3. What is the average age of vehicles involved in accidents based on their type?
SELECT
	VehicleType,
	COUNT(AccidentIndex) AS 'Total Accidents',
	AVG(agevehicle) AS 'Average Year'
FROM
	vehicle
WHERE
	AgeVehicle IS NOT NULL
GROUP BY
	VehicleType
ORDER BY
	'Total Accidents' DESC


-- 4. Can we identify any trends in accidents based on the age of vehicles involved?
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

-- 5. Are there any specific weather condition that contribute to severe accidents?
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

-- 6. Do accidents often involve impacts on the left-hand side of vehicles?
SELECT
	LeftHand,
	COUNT(AccidentIndex) AS 'Total Accidents'
FROM
	vehicle
GROUP BY
	LeftHand
HAVING
	LeftHand IS NOT NULL

-- 7. Are there any relationship between journey purposes and the severity of accidents?
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

-- 8. Calculate the average age of vehicles involved in accidents, considering Day light and point of impact.
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