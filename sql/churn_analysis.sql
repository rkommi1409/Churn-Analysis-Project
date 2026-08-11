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

-- ------------------------------------------------
-- Query 5: Churn rate by MonthlyCharges range
-- Purpose: Test whether higher-paying customers churn
-- more than lower-paying ones
-- ------------------------------------------------
SELECT 
    CASE 
        WHEN MonthlyCharges < 35 THEN 'Under $35'
        WHEN MonthlyCharges < 65 THEN '$35-$65'
        WHEN MonthlyCharges < 95 THEN '$65-$95'
        ELSE '$95+'
    END AS charge_range,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM customers
GROUP BY 
    CASE 
        WHEN MonthlyCharges < 35 THEN 'Under $35'
        WHEN MonthlyCharges < 65 THEN '$35-$65'
        WHEN MonthlyCharges < 95 THEN '$65-$95'
        ELSE '$95+'
    END
ORDER BY churn_rate_pct DESC;

-- Result: $65-$95    -> 35.94% churn (highest risk)
--         $95+       -> 32.26% churn
--         $35-$65    -> 23.15% churn
--         Under $35  -> 10.86% churn (lowest risk)
-- Insight: Churn rises with price but isn't purely linear -
-- the $65-$95 "mid-tier" range churns more than $95+,
-- suggesting perceived value (not just price) drives churn.
-- Likely connects to TechSupport finding - premium bundles
-- may include support that increases perceived value.


-- ------------------------------------------------
-- Query 6: Customer risk segmentation
-- Addresses BRD Functional Requirement: FR-02
-- Purpose: Assign each customer a risk score based on
-- proven churn drivers (Contract, Tenure, TechSupport),
-- then classify into High/Medium/Low risk tiers
-- ------------------------------------------------

SELECT
    customerID,
    Contract,
    tenure,
    TechSupport,
    Churn,
    (
        CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END +
        CASE WHEN tenure <= 12 THEN 2 ELSE 0 END +
        CASE WHEN TechSupport = 0 THEN 1 ELSE 0 END
    ) AS risk_score,
    CASE 
        WHEN (
               CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END +
               CASE WHEN tenure <=12 THEN 2 ELSE 0 END +
               CASE WHEN TechSupport = 0 THEN 2 ELSE 0 END 
            )  >=4 THEN 'High Risk'
        WHEN (
                CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END +
               CASE WHEN tenure <=12 THEN 2 ELSE 0 END +
               CASE WHEN TechSupport = 0 THEN 2 ELSE 0 END 
            )  >=2 THEN 'Medium Risk'
            ELSE 'Low Risk'
    END AS risk_tier
FROM customers;



-- ------------------------------------------------
-- Query 7: Risk tier summary with revenue at risk
-- Addresses BRD Functional Requirements: FR-02, FR-03
-- Purpose: Summarize customer counts, churn rate, and
-- Monthly Recurring Revenue at risk per risk tier
-- ------------------------------------------------


SELECT
    risk_tier,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS actual_churned,
    CAST(SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS actual_churn_rate_pct,
    CAST(SUM(MonthlyCharges) AS DECIMAL(10,2)) AS total_mrr_in_tier
FROM (
    SELECT
        customerID,
        Churn,
        MonthlyCharges,
        CASE 
            WHEN (
                CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END +
                CASE WHEN tenure <= 12 THEN 2 ELSE 0 END +
                CASE WHEN TechSupport = 0 THEN 1 ELSE 0 END
            ) >= 4 THEN 'High Risk'
            WHEN (
                CASE WHEN Contract = 'Month-to-month' THEN 2 ELSE 0 END +
                CASE WHEN tenure <= 12 THEN 2 ELSE 0 END +
                CASE WHEN TechSupport = 0 THEN 1 ELSE 0 END
            ) >= 2 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_tier
    FROM customers
) AS scored_customers
GROUP BY risk_tier
ORDER BY total_mrr_in_tier DESC;




