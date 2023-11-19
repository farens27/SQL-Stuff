# 💼 Career Track Analysis

## 📝 Case Description
One of the functionalities the 365 company introduced in a 2021 platform release included the option for student enrollment in a career track. The tracks represent an ordinal sequence of courses that eventually lead to obtaining the skills for one of three job titles: data scientist, data analyst, or business analyst.

Completing a career track on the platform is a challenging task. To acquire a corresponding career certificate, a student must pass nine-course exams (seven compulsory and two elective courses) and sit for a career track exam encompassing topics from all seven required courses.

In this Career Track Analysis with SQL and Tableau project, you’re tasked with analyzing the career track enrollments and achievements of 365’s students. You’ll first need to retrieve the necessary information from an SQL database. Afterward, you’ll feed this information to Tableau, visualize the results, and finally interpret them.

##  Metadata
* track_id =>  the unique identification of a track, which serves as the primary key to the table.
* track_name => the name of the track.
* student_id => the unique identification of a student.
* date_enrolled => the date the student enrolled in the track. A student can enroll in more than one career track.
* date_completed =>  the date the student completed the track. If the track is not completed, the field is NULL.

##  Data Set
Career track enrollments of 365's students [data](https://github.com/farens27/SQL-Stuff/blob/main/MySQL/Career%20Track%20Analysis%20with%20SQL%20and%20Tableau/Career%20Track%20Data.sql)

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
