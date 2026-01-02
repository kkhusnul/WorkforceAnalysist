SELECT *
FROM employee;

-- Employee Attrition Overview
--- What percentage of employees have left vs are still active?
SELECT
 CASE
  WHEN Attrition = 1 THEN 'EXITED'
  ELSE 'ACTIVE'
  END AS 'Employee_Status',
 COUNT(*) as Total_Employee,
 ROUND(
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()
  , 2 ) AS Percentage
FROM employee
WHERE Attrition IS NOT NULL
GROUP BY 1
ORDER BY 1;

--- Which departments experience the highest attrition rates?
WITH dept_attrition AS (
  SELECT
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS exited_employees
  FROM employee
  GROUP BY department
)
SELECT
  department,
  total_employees,
  exited_employees,
  ROUND(exited_employees * 100.0 / total_employees, 2) AS dept_attrition_rate,
  ROUND(
    SUM(exited_employees) OVER () * 100.0 / SUM(total_employees) OVER (),
    2
  ) AS company_attrition_rate,
  ROUND(
    (exited_employees * 100.0 / total_employees) -
    (SUM(exited_employees) OVER () * 100.0 / SUM(total_employees) OVER ()),
    2
  ) AS variance_vs_company
FROM dept_attrition
ORDER BY variance_vs_company DESC;

--- How do employee salaries rank within each department?
SELECT
EmployeeNumber,
Department,
MonthlyIncome,
ROUND(
PERCENT_RANK() OVER (PARTITION BY Department ORDER BY MonthlyIncome
) * 100, 2) AS salary_percentile_in_department
FROM employee
ORDER BY Department, salary_percentile_in_department;

-- Attrition Analysis
-- Do employees with lower job satisfaction leave more often?
SELECT
 CASE
  WHEN JobSatisfaction BETWEEN 1 AND 2 THEN 'Less Satisfied'
  WHEN JobSatisfaction = 3 THEN 'Satisfied'
  ELSE 'Very Satisfied'
  END AS Employee_Job_Satisfication,
 COUNT(*) AS Total_Employee,
 SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS Total_Exited,
 ROUND(SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Exited_Percentage
FROM employee
WHERE JobSatisfaction IS NOT NULL
GROUP BY 1
ORDER BY 4 DESC;

--- At what tenure stage is attrition most likely?
SELECT
 CASE
  WHEN YearsAtCompany > 5 THEN '> 5 Years'
  WHEN YearsAtCompany BETWEEN 3 AND 5 THEN '3 - 5 Years'
  WHEN YearsAtCompany BETWEEN 1 AND 3 THEN '1 - 3 Years'
  ELSE '<1 Years'
  END AS Years_Of_Employment,
 COUNT(*) AS Total_Employee,
 SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS Total_Exited,
 ROUND(SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Exited_Percentage
FROM employee
GROUP BY 1
ORDER BY 4 DESC;

--- Is lower income associated with higher attrition?
SELECT
 CASE
  WHEN Attrition = 1 THEN 'EXITED'
  ELSE 'ACTIVE'
  END AS 'Employee_Status',
 ROUND(avg(MonthlyIncome),2) AS Avg_Monthly_Income
FROM employee
WHERE Attrition IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC;

SELECT
 CASE
  WHEN tile = 1 THEN 'Low'
  WHEN tile = 2 THEN 'Medium'
  WHEN tile = 3 THEN 'High'
  END AS Monthly_Income_Segment,
 COUNT(*) AS Total_Employee,
 SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS Total_Exited,
 ROUND(SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Exited_Percentage
FROM (
 SELECT
  *,
  NTILE(3) OVER (ORDER BY MonthlyIncome) AS tile
  FROM employee
) t
GROUP BY 1
ORDER BY 4 DESC;

--- Does overtime increase attrition risk?
SELECT
 Overtime,
 COUNT(*) AS Total_Employee,
 SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS Total_Exited,
 ROUND(SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Exited_Percentage
FROM employee
WHERE Attrition IS NOT NULL
GROUP BY 1
ORDER BY 4 DESC;

--- Does manager tenure affect team attrition?
SELECT
  CASE
    WHEN YearsWithCurrManager < 2 THEN '< 2 years'
    WHEN YearsWithCurrManager BETWEEN 2 AND 5 THEN '2–5 years'
    ELSE '5+ years'
  END AS manager_tenure_length,
  ROUND(
    SUM(CASE WHEN attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2
  ) AS attrition_rate
FROM employee
GROUP BY 1
ORDER BY 2 DESC;

-- Employee Attrition Risk Score
--- Parameter : Low satisfaction, Low salary growth, Long time since promotion
SELECT
 EmployeeNumber,
 ROUND(
 (JobSatisfaction / MAX(JobSatisfaction) OVER()) 
 * 100.0, 2) as satisfaction_score,
 ROUND(
 (PercentSalaryHike / MAX(PercentSalaryHike) OVER()) 
 * 100.0, 2) as salary_growth_score,
 ROUND(
 (YearsSinceLastPromotion / MAX(YearsSinceLastPromotion) OVER()) 
 * 100.0, 2) as last_promotion_score
 from employee;
 
 --- Which employees are at highest risk of leaving?
 WITH risk_score AS (
 SELECT
  EmployeeNumber,
  (
  CASE WHEN JobSatisfaction <= 2 THEN 3 ELSE 0 END +
  CASE WHEN overtime = 'Yes' THEN 2 ELSE 0 END +
  CASE WHEN YearsSinceLastPromotion >= 3 THEN 2 ELSE 0 END +
  CASE WHEN MonthlyIncome < 5000 THEN 1 ELSE 0 END
  )
  AS attrition_risk_score
  FROM employee
  )
  SELECT
  EmployeeNumber,
  attrition_risk_score,
  RANK() OVER (ORDER BY attrition_risk_score DESC) AS risk_rank
  FROM risk_score
  ORDER BY 3
  Limit 50;
 
-- Performance Analysis
--- Are high-performing employees being promoted proportionally?
SELECT
 PerformanceRating,
 ROUND(AVG(YearsSinceLastPromotion),2) as Avg_Last_Promotion,
 COUNT(*) as Total_Employee
FROM employee
GROUP BY 1
ORDER BY 1;

--- Do employees with more training have better performance or lower attrition?
SELECT
 CASE
  WHEN tile = 1 THEN 'Low'
  WHEN tile = 2 THEN 'Medium'
  WHEN tile = 3 THEN 'High'
  END AS Training_Count,
 ROUND(AVG(PerformanceRating),2) as Avg_PerformanceRating,
 COUNT(*) AS Total_Employee,
 SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) AS Total_Exited,
 ROUND(SUM(CASE WHEN Attrition = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Exited_Percentage
FROM (
 SELECT
  *,
  NTILE(3) OVER (ORDER BY TrainingTimesLastYear) AS tile
  FROM employee
) t
GROUP BY 1
ORDER BY 2 DESC;

-- Employee Well-Being Analysis
SELECT
 ROUND(AVG(WorkLifeBalance),2) avg_wlb_score,
 ROUND(AVG(PercentSalaryHike),2) avg_salary_hike,
 ROUND(AVG(EnvironmentSatisfaction),2) avg_Environment_Satisfaction,
 ROUND(AVG(RelationshipSatisfaction),2) avg_Relationship_Satisfaction,
 ROUND(AVG(JobSatisfaction),2) avg_Job_Satisfaction
FROM employee;


