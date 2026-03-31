--Which occupations have the best credit profiles?
SELECT Occupation,
       ROUND(AVG(CASE WHEN credit_mix = 'Good' THEN 2 
                      WHEN credit_mix = 'Standard' THEN 1
                      WHEN credit_mix = 'Bad' THEN 0
                      ELSE NULL
                      END),4) AS avg_credit_score
FROM creditclass
GROUP BY Occupation
ORDER BY avg_credit_score DESC;


--How does age group affect borrowing behavior?
--TO GET DISTINCT CUSTOMER COUNT BY AGE RANGE
SELECT CASE WHEN Age BETWEEN 1 AND 24 THEN '1-24'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            WHEN Age BETWEEN 55 AND 64 THEN '55-64'
            ELSE '75+'
            END AS Age_range,
COUNT (DISTINCT customer_id) AS customer_count
FROM creditclass
GROUP BY 
    CASE WHEN Age BETWEEN 1 AND 24  THEN '1-24'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '75+' 
    END
ORDER BY Age_range;            
--Therefore age group vs borrowing behavior? , customer id was added in the subquery so the outer query would count it too
SELECT Age_range,
       COUNT(DISTINCT Customer_ID) AS customer_count,
       ROUND(AVG(num_of_loan), 2) AS avg_num_loans,
       ROUND(AVG(CASE WHEN credit_mix = 'Good' THEN 2 
                      WHEN credit_mix = 'Standard' THEN 1
                      WHEN credit_mix = 'Bad' THEN 0
                      ELSE NULL
                      END),2) AS avg_credit_score
FROM (
      SELECT CASE WHEN Age BETWEEN 1 AND 24 THEN '1-24'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            WHEN Age BETWEEN 55 AND 64 THEN '55-64'
            ELSE '75+'
            END AS Age_range,
            Customer_ID, 
            num_of_loan,
            credit_mix
            FROM creditclass )
GROUP BY Age_range
ORDER BY Age_range;


--Which income band carries the most debt?
--In Oracle, (quartiles) is the NTILE(4) window function.
--It divides your result set into four equal groups based on the order you provide
--Taking income quartiles as a CTE instead of a subquery, over() fxn tells to pass an aggregate value over d existing result
WITH income_quartiles AS (
    SELECT 
        Customer_ID,
        Outstanding_Debt,
        Monthly_Inhand_Salary,
        annual_income,
        NTILE(4) OVER (ORDER BY annual_income) AS quartile
    FROM creditclass
)
SELECT 
    CASE quartile
        WHEN 1 THEN 'Low level income'
        WHEN 2 THEN 'mid level income'
        WHEN 3 THEN 'High level income'
        ELSE 'Very high level income'
    END AS income_band,
    ROUND(AVG(Outstanding_Debt), 4) AS avg_debt,
    ROUND(SUM(Outstanding_Debt), 4) AS total_debt,
    COUNT(Customer_ID) AS customer_count,
    ROUND(AVG(Monthly_Inhand_Salary), 4) AS avg_monthly_salary
FROM income_quartiles
GROUP BY quartile
ORDER BY quartile;


--What credit mix predicts default risk?
SELECT
    credit_mix,
    COUNT(Customer_ID) AS customer_count,
    ROUND(AVG(num_of_delayed_payment),2) AS avg_delayed_payments,
    ROUND(AVG(delay_from_due_date),2) AS avg_delay_days,
    ROUND(AVG(outstanding_debt),2) AS avg_outstanding_debt,
    ROUND(AVG(num_of_loan),2) AS avg_num_loans
FROM creditclass
GROUP BY credit_mix;
        
        
How does credit history length affect risk?
SELECT history_band,
    COUNT(Customer_ID) AS customer_count,
     ROUND(AVG(num_of_delayed_payment),2) AS avg_delayed_payments,
     ROUND(AVG(outstanding_debt),2) AS avg_outstanding_debt,
     ROUND(AVG(CASE WHEN credit_mix = 'Good' THEN 2 
                      WHEN credit_mix = 'Standard' THEN 1
                      WHEN credit_mix = 'Bad' THEN 0
                      ELSE NULL
                      END),2) AS avg_credit_score
FROM (
    SELECT Customer_ID,
        num_of_delayed_payment,
        outstanding_debt,
        credit_mix,
        CASE
            WHEN credit_history_age_months BETWEEN 0   AND 59  THEN '0–59 Mnths'
            WHEN credit_history_age_months BETWEEN 60  AND 119 THEN '60–119 Mnths'
            WHEN credit_history_age_months BETWEEN 120 AND 199 THEN '120–199 Mnths'
            WHEN credit_history_age_months BETWEEN 200 AND 399 THEN '200–399 Mnths'
            ELSE '400+ Mnths'
        END AS history_band
        FROM creditclass
    WHERE credit_mix IN ('Good', 'Standard', 'Bad', 'Unknown')
)
GROUP BY history_band
ORDER BY history_band;


--How does credit inquiries trend across months?
SELECT Month, SUM(Num_Credit_Inquiries) AS total_num_credit_inquiries
FROM creditclass
GROUP BY Month
ORDER BY total_num_credit_inquiries DESC;