# 💼 Career Track Analysis

## 💡 Solution

### 1. Start with a subquery that joins the tables career_track_student_enrollments and career_track_info based on the common column, track_id. Select the appropriate columns from this join and create three new columns: student_track_id, track_completed, and days_for_completion.

````sql
SELECT
  e.student_id,
  i.track_name,
  e.date_enrolled,
  ROW_NUMBER () OVER (ORDER BY e.student_id, i.track_name) AS student_track_id,
  IF(date_completed IS NULL,0, 1 ) AS track_completed,
  DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion 
FROM
  career_track_student_enrollments AS e
    INNER JOIN
  career_track_info AS I
    ON
  e.track_id = i.track_id
````

**The following line of code:**

````sql
ROW_NUMBER () OVER (ORDER BY e.student_id, i.track_name) AS student_track_id
````

Assigns a unique identifier to each row (student-track pair) in the result set based on the ordering of student_id and track_name. The resulting column is named student_track_id.

**The following:**

````sql
IF(date_completed IS NULL,0, 1 ) AS track_completed
````

Assigns a value of 0 to the track_completed column if date_completed is NULL, indicating that the track is not completed. Otherwise, it assigns a value of 1, meaning the track is finished.

**Lastly, let’s also discuss the following line:**

````sql
DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
````

It calculates the number of days it took to complete a track by subtracting date_enrolled from date_completed for each row. It then assigns the result to the days_for_completion column.

### 2. Enclose the subquery in parentheses and give it an alias, a:

````sql
(
SELECT 
  e.student_id,
  i.track_name,
  e.date_enrolled,
  ROW_NUMBER () OVER (ORDER BY e.student_id, i.track_name) AS student_track_id, 
  IF(date_completed IS NULL,0, 1 ) AS track_completed, 
  DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
FROM
  career_track_student_enrollments AS e
    INNER JOIN
  career_track_info AS i 
    ON
  e.track_id = i.track_id 
) AS a;
````

### 3. In the main query, select the desired columns from the subquery and add a CASE statement for the completion_bucket column. The statement allows you to perform conditional logic in SQL; it behaves similarly to if-else conditions in programming. Each WHEN clause within the CASE statement will check if days_for_completion falls within a specific range, and the THEN clause will assign the appropriate bucket label. After writing all the WHEN-THEN pairs, finish the CASE statement with the END keyword.

**Below is the full query for the task:**

````sql
USE sql_and_tableau;

SELECT
  student_track_id,
  student_id,
  track_name,
  date_enrolled,
  track_completed,
  days_for_completion,
  CASE
    WHEN days_for_completion = 0 THEN 'Same Day'
    WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 Days'
    WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 Days'
    WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 Days'
    WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 Days'
    WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 Days'
    ELSE '366+ Days'
    END AS completion_bucket
FROM (
  SELECT 
    e.student_id,
    i.track_name,
    e.date_enrolled,
    ROW_NUMBER () OVER (ORDER BY e.student_id, i.track_name) AS student_track_id,
    IF(date_completed IS NULL,0, 1 ) AS track_completed,
    DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
  FROM
    career_track_student_enrollments AS e
      INNER JOIN
    career_track_info AS i 
      ON
    e.track_id = i.track_id
) AS a;
````
