SELECT department, AVG(MonthlyIncome)
FROM employee
GROUP BY department
ORDER BY AVG(MonthlyIncome);

SELECT department, COUNT(department)
FROM employee
GROUP BY department;

SELECT department,AVG(Age)
FROM employee
GROUP BY department;

--What is the overall attrition rate in the company?
--total employees that resigned
SELECT COUNT(*) AS  resigned_employees
FROM employee
WHERE Attrition = 'Yes';

 

--attrition rate,attrition column is in txt,so Case statement is like "if this then that" statement,then we summed it,divided by100 and round up
SELECT COUNT(*) AS  total_employees,
ROUND(
     SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),
     2) AS attrition_rate
FROM employee;     

---- Q2. Which department has the highest attrition rate?
SELECT
    Department,
SELECT Department , 
       COUNT(*) AS "total employees" ,
       ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END)* 100.0 / COUNT(*),2) AS attrition_rate
FROM employee
GROUP BY Department
ORDER BY attrition_rate DESC;

--What is the average monthly income by department and job role?
SELECT Department, JobRole, ROUND(AVG(MonthlyIncome),2) AS average_monthly_income
FROM employee
GROUP BY Department, JobRole
ORDER BY Department,average_monthly_income DESC;


-- Q10. Do higher salary hike percentages reduce attrition?
SELECT 
   CASE 
      WHEN PercentSalaryHike BETWEEN 11 AND 14 THEN '11-14%'
      WHEN PercentSalaryHike BETWEEN 15 AND 18 THEN '15-18%'
      WHEN PercentSalaryHike BETWEEN 19 AND 22 THEN '19-22%'
      ELSE '23%+'
   END AS hike_range,
   COUNT(*) AS total_employees,
   SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS resigned_employees,
   ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee
GROUP BY 
   CASE 
      WHEN PercentSalaryHike BETWEEN 11 AND 14 THEN '11-14%'
      WHEN PercentSalaryHike BETWEEN 15 AND 18 THEN '15-18%'
      WHEN PercentSalaryHike BETWEEN 19 AND 22 THEN '19-22%'
      ELSE '23%+'
   END
ORDER BY hike_range;

-- Q12. What is the income distribution across job levels?
SELECT JobLevel, ROUND(AVG(MonthlyIncome),1)AS average_income, 
                 MAX(MonthlyIncome)AS Maximum_income, 
                 MIN(MonthlyIncome) AS Minimum_income,
                 COUNT(*) AS employee_count
FROM employee
GROUP BY JobLevel
ORDER BY JobLevel DESC;


-- Q13. Which departments have the highest average performance ratings?
SELECT Department, ROUND(AVG(PerformanceRating),2) AS Average_Performance_Rating
FROM employee
GROUP BY Department
ORDER BY Average_Performance_Rating DESC;

-- Q15. How long does the average employee go without a promotion?
SELECT Department, COUNT(*) , ROUND(AVG(YearsSinceLastPromotion),2) AS avg_years_since_promotion
FROM employee
GROUP BY Department
ORDER BY avg_years_since_promotion DESC ;

-- Q16. Is there a link between years since last promotion and attrition?

SELECT 
  CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Just Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 3  THEN '1-3 years'
        WHEN YearsSinceLastPromotion BETWEEN 4 AND 7  THEN '4-7 years'
        ELSE '8+ years'
    END    AS promotion_gap,
  COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS  resigned_employees
FROM employee
GROUP BY CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Just Promoted'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 3  THEN '1-3 years'
        WHEN YearsSinceLastPromotion BETWEEN 4 AND 7  THEN '4-7 years'
        ELSE '8+ years' END 
ORDER BY resigned_employees;       
  

-- Q17. Do high performers receive proportionally higher salary hikes?
SELECT PerformanceRating, ROUND(AVG(PercentSalaryHike),2) AS Average_SalaryHike_Pct
FROM employee
GROUP BY PerformanceRating
ORDER BY PerformanceRating DESC;

-- Q18. Which job roles report the lowest job satisfaction?
SELECT JobRole,ROUND(AVG(JobSatisfaction),2)AS avg_job_satisfaction, COUNT(*) AS total_employees
FROM employee
GROUP BY JobRole
ORDER BY avg_job_satisfaction;

--Do employees with low job involvement leave more often?
SELECT  JobInvolvement, COUNT(*) AS total_employees,
  SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS resigned_employees,
ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0/ COUNT(*), 2 ) AS attrition_rate_pct  
FROM employee
GROUP BY JobInvolvement
ORDER BY JobInvolvement;

-- Q23. What is the age distribution of the workforce?
--CREATE A SUBQUERY TO GET D AGE INTO GROUPS
SELECT 
   CASE 
      WHEN Age BETWEEN 18 AND 19  THEN '18-19years'
      WHEN Age BETWEEN 20 AND 29  THEN '21-29years'
      WHEN Age BETWEEN 30 AND 39  THEN '30-39years'
      WHEN Age BETWEEN 40 AND 49  THEN '40-49years'
      WHEN Age BETWEEN 50 AND 59  THEN '50-59years'
      ELSE '60' END AS age_group,
COUNT (*) AS total_employees
FROM employee
GROUP BY CASE 
      WHEN Age BETWEEN 18 AND 19  THEN '18-19years'
      WHEN Age BETWEEN 20 AND 29  THEN '21-29years'
      WHEN Age BETWEEN 30 AND 39  THEN '30-39years'
      WHEN Age BETWEEN 40 AND 49  THEN '40-49years'
      WHEN Age BETWEEN 50 AND 59  THEN '50-59years'
      ELSE '60' END;
 --WRITE MAIN QUERY AND INCLUDE THE SUBQUERY
 
SELECT age_group,total_employees
 FROM (
    SELECT CASE 
      WHEN Age BETWEEN 18 AND 19  THEN '18-19years'
      WHEN Age BETWEEN 20 AND 29  THEN '21-29years'
      WHEN Age BETWEEN 30 AND 39  THEN '30-39years'
      WHEN Age BETWEEN 40 AND 49  THEN '40-49years'
      WHEN Age BETWEEN 50 AND 59  THEN '50-59years'
      ELSE '60' END AS age_group,
COUNT (*) AS total_employees
FROM employee
GROUP BY 
   CASE WHEN Age BETWEEN 18 AND 19  THEN '18-19years'
        WHEN Age BETWEEN 20 AND 29  THEN '21-29years'
        WHEN Age BETWEEN 30 AND 39  THEN '30-39years'
        WHEN Age BETWEEN 40 AND 49  THEN '40-49years'
        WHEN Age BETWEEN 50 AND 59  THEN '50-59years'
        ELSE '60' END
      )
ORDER BY age_group;      

-- Q26. What percentage of the workforce is at each job level?
--write a subquery for employee headcount on a job level and total head count
SELECT JobLevel, COUNT(*) AS employees_headcount,
FROM employee
GROUP BY Joblevel;

--write main query
SELECT JobLevel, employees_headcount, ROUND(employees_headcount *100.0 /SUM(employees_headcount)OVER(),2) AS pct_of_workforce
FROM (
       SELECT JobLevel, COUNT(*) AS employees_headcount
       FROM employee
       GROUP BY Joblevel)
ORDER BY JobLevel;       
