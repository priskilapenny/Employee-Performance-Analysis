CREATE VIEW timesheet_details AS
WITH ts_overdue AS (
	SELECT *, CASE
		WHEN finish_date < CURDATE() AND ISNULL(DATE(submit_date)) THEN 1
		WHEN DATE(submit_date) > finish_date THEN 1
		ELSE 0
		END AS overdue
	FROM employee_timesheet
)
SELECT a.emp_timesheet_id, a.employee_id, a.overdue, a.start_date, a.date_created, COUNT(b.emp_task_id) total_task, IFNULL(SUM(b.hours), 0) total_hour, c.full_name, d.team_id, d.team_name, DATE(c.inactive_at) emp_inactive_date
FROM ts_overdue a
LEFT JOIN emp_timesheet_task b ON a.emp_timesheet_id=b.emp_timesheet_id
LEFT JOIN employee c ON a.employee_id=c.employee_id
LEFT JOIN team_list d ON c.team_id=d.team_id
GROUP BY a.emp_timesheet_id;