-- total active employee
SELECT COUNT(employee_id) total_employee
FROM employee;

-- average hours
SELECT SUM(total_hour) total_work_hour
FROM timesheet_details;

-- Total Tasks
SELECT SUM(total_task) total_tasks
FROM timesheet_details;

