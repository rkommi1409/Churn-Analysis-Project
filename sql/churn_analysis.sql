use CloudSuiteChurn;

-- ------------------------------------------------
-- Query 1: Overall churn rate (baseline)
-- Purpose: Establish the reference churn % that all
-- other segments will be compared against
-- ------------------------------------------------
SELECT 
    Churn,
    COUNT(*) AS customer_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5,2)) AS percentage
FROM customers
GROUP BY Churn;

-- ------------------------------------------------
-- Query 2: Churn rate by Contract type
-- Purpose: Test whether contract commitment length
-- is correlated with churn
-- ------------------------------------------------

SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- ------------------------------------------------
-- Query 3: Churn rate by Tenure group
-- Purpose: Test whether newer customers (shorter
-- tenure) churn at a higher rate than long-standing
-- customers
-- ------------------------------------------------

SELECT 
  CASE 
      WHEN tenure <= 12 THEN '0-12 months'
      WHEN tenure <= 24 THEN '13-24 months'
      WHEN tenure <= 48 THEN '25-48 months'
      ELSE '49+ months'
    END AS tenure_group,
    COUNT(*) AS tenure_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_cuatomers,
    CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) *100.0 /COUNT(*) AS DECIMAL(5, 2 )) AS churn_rate_pct
FROM Customers
GROUP BY 
  CASE 
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    WHEN tenure <= 48 THEN '25-48 months'
  ELSE '49+ months'
 END 
ORDER BY churn_rate_pct DESC;

-- Result: 0-12 months  -> 47.44% churn (highest risk)
--         13-24 months -> 28.71% churn
--         25-48 months -> 20.39% churn
--         49+ months   -> 9.51% churn (lowest risk)
-- Insight: Churn risk declines steadily with tenure -
-- new customers churn ~5x more than long-tenured ones.

-- ------------------------------------------------
-- Query 4: Churn rate by TechSupport
-- Purpose: Test whether lack of tech support access
-- is correlated with higher churn
-- ------------------------------------------------

SELECT 
     TechSupport,
     COUNT(*)  AS total_customers,
     SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS chruned_customers,
     CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END)* 100.0/ COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
     FROM Customers
     GROUP BY TechSupport
     ORDER BY churn_rate_pct DESC;

-- Result: No TechSupport  -> 41.64% churn (high risk)
--         Has TechSupport -> 15.17% churn
--         No internet svc -> 7.40% churn (simpler service, lower risk)
-- Insight: Lack of tech support is a strong churn driver -
-- customers without it churn ~3x more than those with it.
-- Note: TechSupport imported as bit (0/1/NULL) instead of
-- text - same quirk as Churn column.
