# 💼 Career Track Analysis

## 📝 Case Description
One of the functionalities the 365 company introduced in a 2021 platform release included the option for student enrollment in a career track. The tracks represent an ordinal sequence of courses that eventually lead to obtaining the skills for one of three job titles: data scientist, data analyst, or business analyst.

Completing a career track on the platform is a challenging task. To acquire a corresponding career certificate, a student must pass nine-course exams (seven compulsory and two elective courses) and sit for a career track exam encompassing topics from all seven required courses.

In this Career Track Analysis with SQL and Tableau project, you’re tasked with analyzing the career track enrollments and achievements of 365’s students. You’ll first need to retrieve the necessary information from an SQL database. Afterward, you’ll feed this information to Tableau, visualize the results, and finally interpret them.

## 💾 Metadata
* track_id =>  the unique identification of a track, which serves as the primary key to the table.
* track_name => the name of the track.
* student_id => the unique identification of a student.
* date_enrolled => the date the student enrolled in the track. A student can enroll in more than one career track.
* date_completed =>  the date the student completed the track. If the track is not completed, the field is NULL.

## 📁 Data Set
Career track enrollments of 365's students [data](https://github.com/farens27/SQL-Stuff/blob/main/MySQL/Career%20Track%20Analysis%20with%20SQL%20and%20Tableau/Career%20Track%20Data.sql)

## 🔧 Tools
* MySQL 8.0.35 for data analysis - View [SQL Scripts](https://github.com/farens27/SQL-Stuff/blob/main/MySQL/Career%20Track%20Analysis%20with%20SQL%20and%20Tableau/Solution.sql)
* Tableau for data visualization - View [Dashboard](https://public.tableau.com/app/profile/farensa.fernanda/viz/CareerTrackAnalysis_17003774438490/CareerTrackAnalysis)

## Dashboard
![image](https://github.com/farens27/SQL-Stuff/assets/60220519/941f95ce-4f88-44f7-b32d-76566e84de44)

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
USE solution;

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

## 📊 Interpreting the Results

### 1. What is the number of enrolled students monthly? Which is the month with the most enrollments? Speculate about the reason for the increased numbers.
Let’s study the combo chart, showing the number of monthly career track enrollments and the fraction of students who complete the track not necessarily within the month of enrollment.
![image](https://github.com/farens27/SQL-Stuff/assets/60220519/695a56ee-1652-47d3-826a-48986fdd20ee)
Studying the height of the bars, we observe a fluctuating number of people enrolling monthly (roughly 800 and 1,200), with August registering a higher number. The reason is a campaign that 365 ran for three days which gave all its students free access to the platform. We can see that this has both boosted the number of enrollments and, as a result, the completion rate. Still, most people enrolled in this period seem to have started the track but have given up once the free days ended.

### 2. Which career track do students enroll most in?
When considering the number of enrolled students per track, the data analyst career track is the most sought after among 365 students, followed by the data science track and, finally, the business analyst one.
![image](https://github.com/farens27/SQL-Stuff/assets/60220519/60c53f62-2ea6-4380-a540-e9c1b6ec40da)

### 3. What is the career track completion rate? Can you say if it’s increasing, decreasing, or staying constant with time?
Studying the line part of the combo chart, we see the numbers fluctuating. But the passing rate (around 2%) is relatively low, with numbers varying between tracks. Therefore, it’s difficult to state any dependency with time—i.e., we can’t conclude with certainty the completion rate increases, decreases, or stays constant.
![image](https://github.com/farens27/SQL-Stuff/assets/60220519/695a56ee-1652-47d3-826a-48986fdd20ee)

### 4. How long does it typically take students to complete a career track? What type of subscription is most suitable for students who aim to complete a career track: monthly, quarterly, or annual?
We can argue, that students need a lot of time to complete an entire career track. This claim is supported by the second bar chart created in the project, where we’ve seen that it takes students an annual subscription to complete a single career track.
![image](https://github.com/farens27/SQL-Stuff/assets/60220519/929e08ac-6ec5-4852-90a8-bcc78ea46ffa)
Such an analysis should therefore be conducted for long periods. The SQL database shows that the last completion date recorded is May 16, 2023. If we assume that it takes roughly a year for students to complete a track, then people registered towards the end of the period under analysis have yet to complete theirs.

### 5. What advice and suggestions for improvement would you give the 365 team to boost engagement, increase the track completion rate, and motivate students to learn more consistently? 
Given the relatively low success rate of 2% in completing a career track, we can appreciate how much effort, engagement, and persistence it requires to complete one. Students need to complete nine courses, pass nine-course exams, and the career track itself—encompassing topics from all seven compulsory courses entering the track. We understand that this can make students feel overwhelmed and discouraged.

The 365 team put much effort into engaging their students and helping them reach their goals. We launched a gamified version of the platform, which allows for maintaining streaks and, as a reward, claiming great prizes. Students are also encouraged to participate in the News Feed option of the platform, share their thoughts and learning progress, and seek help from instructors and fellow students in the Q&A hub.
