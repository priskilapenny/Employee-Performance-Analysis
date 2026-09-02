# Employee Performance Analysis
## Project Overview
This project analyzes employee performance in an advertising agency using MySQL and Power BI for visualization. The analysis aims to identify performance trends, workload distribution, and employee performance ranks.

The goal is to answer key business questions such as:
- Who are the top and bottom performers?
- How is employee performance distributed
- Is there a relationship between tasks completed and work hours?
- How does employee performance change month over month?

## Tech Stack
- MySQL
    - Window Function (Aggregate Function, Value Function, Rank Function)
    - Case When Expression
    - CTE
- Power BI
    - Data Visualization
    - Power Query
    - DAX

## Dataset
The dataset was sourced from the company’s timesheet web app. Sensitive details such as employee names and team names were replaced with dummy values.

Relational tables used in this analysis:
1. employee: employee details
2. employee_timesheet: employee timesheet working on
3. employee_timesheet_task: breakdown tasks of the timesheet employee working on
4. team_list: list of teams
<img width="750" height="461" alt="ERD" src="https://github.com/user-attachments/assets/432f0e4d-3358-469c-b2fe-20a012bec332" />

## Data Preparation
1. Checking missing values
2. Checking duplicate records
3. Validating relationships between tables

## SQL Analysis
`timesheet_details` consolidates employee task and timesheet data into an analytical dataset used for the analysis.
````sql
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
````

#### 1. Employee Overview
- Count of unique employees
- Sum of total work hours
- Sum of total tasks for each timesheet

View SQL → [employee_overview.sql](SQL/employee_overview.sql)
#### 2. Performance Analysis
- Percentage of overdue tasks
- Average of employee performance
- Highest-performing employee
- Lowest-performing employee
````sql
-- bottom 5 performers
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
````
View SQL → [performance_analysis.sql](SQL/performance_analysis.sql)
#### 3. Workload Analysis
- Employee distribution by performance category
- Relationship between tasks completed and work hours

View SQL → [workload_analysis.sql](SQL/workload_analysis.sql)
#### 4. Time-based Analysis
- Month-over-Month percentage point performance
````sql
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
````
View SQL → [time-based_analysis.sql](SQL/time-based_analysis.sql)

## Key Findings & Insight
- Average employee performance stood at 17.43%
- More than 70% of employees are in the unsatisfactory category and there isn’t any employee in the outstanding category.
- The top-performing employees demonstrated consistently strong on-time performance.
- Performance improved by 0.09 percentage points in the latest month.
- The relationship between task volume and work hours does not entirely affect employee performance.

## Recommendation
Based on the analysis:
1. Monitor employees with high overdue rate.
2. Review workload distribution to identify workload imbalance.
3. Investigate employees with high work hours but relatively low task output.
4. Continue monitoring monthly performance trends to evaluate whether improvements are sustained.

## Dashboard
<img width="1286" height="727" alt="dashboard-screenshot" src="https://github.com/user-attachments/assets/d6f43d9c-f93b-48a2-a195-d5fb7603ee42" />

