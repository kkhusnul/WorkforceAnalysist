# WorkforceAnalysist
This project focuses on workforce and employee analytics using SQL to uncover insights related to attrition, performance, compensation, workload, and employee risk. The goal is to transform raw HR data into actionable insights that support better decision-making in retention strategy, workforce planning, and operational efficiency.
All analysis is performed using SQL, emphasizing clear business logic, accuracy, and advanced analytical techniques such as window functions and conditional aggregation.

**Business Objectives**
- Measure overall employee attrition
- Identify key drivers of employee turnover
- Analyze the impact of overtime, salary, tenure, and job satisfaction
- Benchmark departments against company-wide metrics
- Create risk indicators to identify employees likely to leave

**Dataset Description**
The dataset contains employee-level information commonly found in HR systems, including:
Department and job-related attributes
Attrition status
Compensation and overtime data
Job satisfaction and work-life balance
Training, promotion, and performance metrics

(Source : https://www.kaggle.com/datasets/rohitsahoo/employee/data?select=train.csv)

**Key Analysis Scenarios**
1. Employee Attrition Overview
Calculated the percentage of employees who exited versus those who remain active.
Insight: Attrition is not evenly distributed and varies significantly across departments and employee segments.

2. Attrition by Department
Compared attrition rates across departments to identify high-risk operational areas.
Insight: Certain departments consistently show higher turnover, indicating potential workload or management challenges.

3. Overtime vs Attrition Risk
Analyzed whether working overtime increases the likelihood of employee attrition.
Insight: Employees who work overtime exhibit a significantly higher attrition rate, suggesting workload imbalance and burnout risk.

4. Job Satisfaction & Retention
Evaluated how job satisfaction levels relate to employee turnover.
Insight: Lower job satisfaction strongly correlates with higher attrition.

5. Tenure-Based Attrition Analysis
Segmented employees by years at the company to identify critical turnover stages.
Insight: Attrition peaks during early and mid-tenure periods, highlighting onboarding and career development gaps.

6. Salary & Compensation Analysis
Compared compensation levels between retained and exited employees.
Insight: Lower salary bands experience higher attrition, especially when combined with overtime.

7. Training & Performance Alignment
Assessed the relationship between training frequency, performance ratings, and attrition.
Insight: Higher training investment aligns with better performance and improved retention.

8. Advanced Benchmarking Using Window Functions
Benchmarked department-level attrition against company-wide averages to identify variance.
Insight: Window functions enable more actionable insights by highlighting departments performing above or below the organizational norm.

9. Employee Attrition Risk Scoring
Created a composite attrition risk score using multiple indicators:
Job satisfaction
Overtime
Time since last promotion
Compensation level
Insight: Risk scoring helps prioritize retention efforts before attrition occurs.

**SQL Skills & Techniques Used**
- CASE WHEN for conditional logic
- Aggregations (COUNT, SUM, AVG)
- Window functions (RANK, PERCENT_RANK, SUM() OVER()
- Percentage and variance calculations
- Data validation and quality checks

**Business Impact**
- Identified high-risk attrition segments
- Provided data-backed recommendations for HR and leadership
- Enabled proactive workforce management
- Demonstrated how SQL supports real-world business decisions

**Key Takeaway**
This project demonstrates how SQL can be used not only to query data, but to generate meaningful workforce insights that drive retention, performance, and operational improvements.
