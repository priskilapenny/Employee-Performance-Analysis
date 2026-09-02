-- Overdue Rate 
SELECT SUM(total_task) total_task,
	SUM(
		CASE
		WHEN overdue=1 THEN total_task
		ELSE 0
		END
	) AS overdue,
	(SUM(
		CASE
		WHEN overdue=1 THEN total_task
		ELSE 0
		END
	) / SUM(total_task))*100 AS overdue_rate
FROM timesheet_details;

-- Performance Score
-- Employee performance is calculated by 50% of the on-time rate and 50% of total tasks by working hours.
WITH performance_score AS (
	SELECT employee_id, full_name, 
		IFNULL(100 - ((SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100), 0) ontime_rate, 
		IFNULL((SUM(total_task)/SUM(total_hour))*100, 0) task_per_wh,
		IFNULL((0.5 * (100 - (SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100)) + (0.5 * ((SUM(total_task)/SUM(total_hour))*100)), 0) score
	FROM timesheet_details
	GROUP BY employee_id
)
SELECT ROUND(AVG(score), 2) average_perf
FROM performance_score;

-- TOP 5 Performers
WITH performance_score AS (
	SELECT employee_id, full_name, 
		IFNULL(100 - ((SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100), 0) ontime_rate, 
		IFNULL((SUM(total_task)/SUM(total_hour))*100, 0) task_per_wh,
		IFNULL((0.5 * (100 - (SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100)) + (0.5 * ((SUM(total_task)/SUM(total_hour))*100)), 0) score
	FROM timesheet_details
	GROUP BY employee_id
)
SELECT *
FROM (
	SELECT employee_id, full_name, ontime_rate, task_per_wh, score, DENSE_RANK() OVER(ORDER BY score DESC) rank_by_perf
	FROM performance_score
) perf_rank
WHERE rank_by_perf <= 5;

-- Bottom 5 Performers
WITH performance_score AS (
	SELECT employee_id, full_name, 
		IFNULL(100 - ((SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100), 0) ontime_rate, 
		IFNULL((SUM(total_task)/SUM(total_hour))*100, 0) task_per_wh,
		IFNULL((0.5 * (100 - (SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100)) + (0.5 * ((SUM(total_task)/SUM(total_hour))*100)), 0) score
	FROM timesheet_details
	GROUP BY employee_id
)
SELECT *
FROM (
	SELECT employee_id, full_name, ontime_rate, task_per_wh, score, DENSE_RANK() OVER(ORDER BY score ASC) rank_by_perf
	FROM performance_score
) perf_rank
WHERE rank_by_perf <= 5;