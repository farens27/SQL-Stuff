USE solution;

-- Selecting relevant columns for analysis
SELECT
	student_track_id,
    student_id,
    track_name,
    date_enrolled,
    track_completed,
    days_for_completion,

	-- Categorizing completion time into different buckets
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
	-- Subquery to calculate track completion details
	SELECT 
		e.student_id,
		i.track_name,
		e.date_enrolled,
		ROW_NUMBER () OVER (ORDER BY e.student_id, i.track_name) AS student_track_id, -- Generating a unique identifier for each student's track enrollment
		IF(date_completed IS NULL,0, 1 ) AS track_completed, -- Indicator if the track is completed or not (1 for completed, 0 for not completed)
		DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion -- Calculating the number of days taken to complete the track
	 -- Joining tables to get necessary information    
	FROM
		career_track_student_enrollments AS e
			INNER JOIN
		career_track_info AS i 
			ON
		e.track_id = i.track_id -- Joining based on track ID
) AS a;
