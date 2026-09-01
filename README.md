# Employee Performance Analysis
## Project Overview
This project analyzes employee performance in an advertising agency using MySQL and Power BI for visualization. The analysis aims to identify performance trends, workload distribution, and employee performance ranks.

The goal is to answer key business questions such as:
- Who are the top and bottom performers?
- How is employee performance distributed
- Is there a relationship between tasks completed and work hours?
- How does employee performance change month over month?

## Tech Stack
- MySQL (Aggregate, Case When, CTE, Window Function)
- Power BI
    - Data modeling
    - Data Visualization
    - Power Query (Transformation & Table Formatting)
    - DAX (Calculation & Table Creation)

## Data Source
The dataset was sourced from the company’s timesheet web app. Sensitive details such as employee names and team names were replaced with dummy values.

## SQL Analysis
#### 1. Employee Overview
- Count of unique employees
- Sum of total work hours
- Sum of total tasks for each timesheet
#### 2. Performance Analysis
- Percentage of overdue tasks
- Average of employee performance
- Highest-performing employee
- Lowest-performing employee
#### 3. Workload Analysis
- Employee distribution by performance category
- Relationship between tasks completed and work hours
#### 4. Time-based Analysis
- Month-over-Month percentage point performance

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
