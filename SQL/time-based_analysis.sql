-- MoM Performance Change
WITH performance_by_month AS (
	SELECT MONTH(start_date) month_num,
		IFNULL((0.5 * (100 - (SUM(CASE WHEN overdue=1 THEN total_task ELSE 0 END)/SUM(total_task))*100)) + (0.5 * ((SUM(total_task)/SUM(total_hour))*100)), 0) score
	FROM timesheet_details
	GROUP BY MONTH(start_date)
)
SELECT
	month_num, 
	score,
	LAG(score, 1) OVER (ORDER BY month_num) AS pm_score,
	(score - LAG(score, 1) OVER (ORDER BY month_num)) percentage_change
FROM performance_by_month;
