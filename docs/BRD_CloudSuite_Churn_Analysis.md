# Business Requirements Document (BRD)
## Project: Customer Churn Analysis & Retention Strategy — CloudSuite

**Document Version:** 1.0
**Prepared By:** Business Analyst
**Date:** August 2026
**Status:** Draft for Review

---

## 1. Business Objective

CloudSuite is a B2B SaaS company offering a subscription-based project management and team collaboration platform. Over the past two quarters, monthly customer churn has increased noticeably, but leadership lacks visibility into which customer segments are churning, what factors are driving the churn, and whether the trend is likely to continue.

The objective of this project is to analyze historical customer data to identify the primary drivers of churn, quantify the revenue impact, and provide leadership with a data-backed recommendation on whether an automated churn-risk detection system is a worthwhile investment.

**Business Goal:** Reduce customer churn and protect recurring revenue by enabling Customer Success and Product teams to act on clear, prioritized insights rather than anecdotal impressions.

---

## 2. Stakeholders

| Stakeholder | Role | Interest |
|---|---|---|
| VP of Customer Success | Primary sponsor | Wants root causes of churn identified and an actionable plan to reduce it |
| Finance / Revenue Operations | Secondary stakeholder | Wants churn's revenue impact quantified (MRR at risk) |
| Product Team | Secondary stakeholder | Wants to know if churn is tied to product gaps or usage friction |
| Data/IT Team | Implementation support | Would need to support any future automated risk-flagging system |
| Business Analyst (this role) | Project owner | Responsible for requirements, analysis, and recommendation |

---

## 3. Scope

**In Scope:**
- Analysis of historical customer account, subscription, and usage data
- Identification of top churn drivers and at-risk customer segments
- Quantification of revenue impact (Monthly Recurring Revenue at risk)
- A dashboard presenting findings and segments for ongoing monitoring
- A feasibility recommendation on whether to build an automated churn-risk flagging system, including what such a system would require

**Out of Scope:**
- Building or deploying the actual automation/ML system (this project only assesses feasibility)
- Direct customer interviews or surveys (analysis is based on historical data only)
- Changes to product features or pricing (may be informed by findings, but not decided within this project)

---

## 4. Functional Requirements

| ID | Requirement |
|---|---|
| FR-01 | Identify the top 3-5 factors most correlated with customer churn (e.g., contract type, tenure, support ticket volume, usage frequency) |
| FR-02 | Segment customers into risk tiers (e.g., High / Medium / Low risk of churn) based on identified factors |
| FR-03 | Quantify total Monthly Recurring Revenue (MRR) currently at risk from high-risk segments |
| FR-04 | Present findings in an interactive dashboard, filterable by customer segment and time period |
| FR-05 | Provide a documented recommendation on the feasibility, requirements, and risks of an automated churn-risk detection system |
| FR-06 | Flag any data quality or privacy/bias considerations relevant to using this data for automated decision-making |

---

## 5. Success Criteria

- Top churn drivers are identified and supported by data, not assumption
- Customer segments are clearly defined with associated churn risk and revenue impact
- A functional, presentable dashboard is delivered
- A clear go/no-go recommendation on automation is documented, with reasoning
- Stakeholders (hypothetically) can act on findings without needing further clarification

---

## 6. Assumptions & Constraints

**Assumptions:**
- Analysis will use a representative historical dataset (e.g., a public SaaS/telecom churn dataset used as a stand-in for CloudSuite's real data)
- Stakeholder needs are inferred based on typical SaaS business priorities, not live interviews
- "Automation" in this context refers to a rules-based or ML-based system to flag at-risk accounts, not a specific vendor tool

**Constraints:**
- Analysis tools limited to SQL, Python, and Power BI/Tableau
- No access to real-time data; analysis is based on a historical snapshot
- Timeline: self-paced portfolio project, not a live business engagement

---

## 7. Requirements Traceability (Summary)

| Requirement ID | Addressed By |
|---|---|
| FR-01, FR-02 | SQL analysis + segmentation logic |
| FR-03 | SQL revenue calculation |
| FR-04 | Power BI / Tableau dashboard |
| FR-05, FR-06 | Written recommendation memo (separate deliverable) |
