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

