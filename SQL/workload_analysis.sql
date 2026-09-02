-- Performance Distribution
WITH performance_score AS (
	SELECT employee_id, full_name, 
		IFNULL(100 - ((SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100), 0) ontime_rate, 
		IFNULL((SUM(total_task)/SUM(total_hour))*100, 0) task_per_wh,
		IFNULL((0.5 * (100 - (SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100)) + (0.5 * ((SUM(total_task)/SUM(total_hour))*100)), 0) score
	FROM timesheet_details
	GROUP BY employee_id
)
SELECT COUNT(CASE WHEN score < 15 THEN 1 END) Unsatisfactory,
	COUNT(CASE WHEN score BETWEEN 15 AND 30 THEN 1 END) NeedsImprovement,
	COUNT(CASE WHEN score BETWEEN 30 AND 45 THEN 1 END) MeetsExpectation,
	COUNT(CASE WHEN score BETWEEN 45 AND 60 THEN 1 END) ExceedsExpectation,
	COUNT(CASE WHEN score > 60 THEN 1 END) Outstanding
FROM performance_score;

-- tasks vs work hours
SELECT employee_id, full_name, SUM(total_task) total_tasks, SUM(total_hour) total_work_hours
FROM timesheet_details
GROUP BY employee_id, full_name
ORDER BY total_tasks DESC, total_work_hours DESC