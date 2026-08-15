# Customer Churn Analysis & Retention Strategy — CloudSuite

**A Business Analyst / BI Analyst portfolio project** combining requirements gathering, SQL analysis, dashboard design, and a data-backed business recommendation — including an assessment of whether an automated churn-risk detection system is worth building.

---

## The Business Problem

CloudSuite is a fictional B2B SaaS company (project scenario) offering a subscription-based project management platform. Over the past two quarters, customer churn has increased, but leadership has no visibility into which customers are churning or why.

**Goal:** Identify the drivers of churn, quantify the revenue impact, and give leadership a clear, evidence-based recommendation on next steps.

---

## Approach

This project follows a standard BA → BI workflow, end to end:

1. **Requirements gathering** — wrote a full Business Requirements Document (BRD) defining scope, stakeholders, and functional requirements
2. **Data analysis** — used SQL Server to analyze the IBM Telco Customer Churn dataset (7,043 customers) and answer the BRD's functional requirements
3. **Dashboard** — built an interactive Power BI dashboard connected live to the SQL Server database
4. **Recommendation** — wrote a business memo assessing the feasibility of an automated churn-risk detection system

---

## Key Findings

Four factors were found to be strongly correlated with churn:

| Driver | Highest-Risk Group | Churn Rate | Lowest-Risk Group | Churn Rate |
|---|---|---|---|---|
| Contract Type | Month-to-month | 42.71% | Two-year | 2.83% |
| Tenure | 0–12 months | 47.44% | 49+ months | 9.51% |
| Tech Support | No support | 41.64% | Has support | 15.17% |
| Monthly Charges | $65–$95 range | 35.94% | Under $35 | 10.86% |

These drivers were combined into a **risk-tier scoring model** (High / Medium / Low), which was validated against actual churn outcomes:

- **High Risk customers churn at 51.35%** vs. **6.75% for Low Risk** — a 7.6x difference
- High + Medium Risk tiers represent **~$263,837 in Monthly Recurring Revenue** exposed to elevated churn risk

---

## Dashboard

An interactive Power BI dashboard (`dashboard/CloudSuite_Churn_Dashboard.pbix`) includes 7 visuals and 2 slicers, covering:
- Overall churn split
- Churn by contract type, tenure, tech support, and monthly charges
- Risk tier breakdown and revenue at risk

*(Note: GitHub can't preview `.pbix` files directly — download and open in Power BI Desktop to view.)*

---

## Recommendation

Rather than a full build, this project recommends a **low-cost pilot**: share the risk model with Customer Success for 60–90 days, measure whether flagged high-risk customers who receive outreach churn less, then scale up only if the pilot proves the model changes outcomes — not just predicts them.

Full reasoning, including data quality, bias, and privacy considerations, is in the [recommendation memo](docs/Recommendation_Memo_CloudSuite_Churn.md).

---

## Tech Stack

- **SQL Server / SSMS** — data analysis and risk scoring
- **Power BI Desktop** — interactive dashboard
- **Git / GitHub** — version control
- **Markdown** — documentation

---

## Repo Structure

```
Churn-Analysis-Project/
├── docs/
│   ├── BRD_CloudSuite_Churn_Analysis.md        # Full business requirements
│   └── Recommendation_Memo_CloudSuite_Churn.md # Feasibility & recommendation
├── sql/
│   ├── churn_analysis.sql                      # All 7 queries + findings
│   └── README.md                               # Dataset source & setup notes
├── dashboard/
│   └── CloudSuite_Churn_Dashboard.pbix          # Interactive Power BI dashboard
└── README.md                                    # This file
```

---

## Skills Demonstrated

Requirements gathering · BRD writing · SQL (T-SQL, window functions, CASE logic, subqueries) · Data cleaning · Power BI (DAX, data modeling, dashboard design) · Business writing · Risk segmentation · Stakeholder-focused recommendations

---

## Dataset

[IBM Telco Customer Churn dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (Kaggle), used as a stand-in for CloudSuite's real customer data.
