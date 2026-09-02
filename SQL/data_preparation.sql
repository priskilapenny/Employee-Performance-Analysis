-- check duplicate records
SELECT employee_id, COUNT(employee_id) duplicates
FROM employee
GROUP BY employee_id
HAVING duplicates > 1;

-- check missing value
SELECT COUNT(*) total_rows,
	SUM(employee_id IS NULL) null_employee_id,
	SUM(start_date IS NULL) null_start_date
FROM employee_timesheet;

SELECT COUNT(*) total_rows,
	SUM(emp_timesheet_id IS NULL) null_timesheet_id,
	SUM(hours IS NULL) null_hours
FROM emp_timesheet_task;

-- relationship check
SELECT a.*, b.employee_id
FROM employee_timesheet a
LEFT JOIN employee b ON a.employee_id=b.employee_id
WHERE b.employee_id IS NULL;

SELECT a.*, b.emp_timesheet_id
FROM emp_timesheet_task a
LEFT JOIN employee_timesheet b ON a.emp_timesheet_id=b.emp_timesheet_id
WHERE b.emp_timesheet_id IS NULL;

SELECT a.*, b.team_id
FROM employee a
LEFT JOIN team_list b ON a.team_id=b.team_id
WHERE b.team_id IS NULL;