# Recommendation Memo: Automated Churn-Risk Detection System
## Project: Customer Churn Analysis & Retention Strategy — CloudSuite

**Document Version:** 1.0
**Prepared By:** Business Analyst
**Date:** August 2026
**Addresses BRD Functional Requirements:** FR-05, FR-06

---

## Executive Summary

CloudSuite's churn rate over the past two quarters has raised concern among leadership, but until now there has been limited visibility into why customers are leaving. This analysis of 7,043 customer records identified four clear, data-backed churn drivers — contract type, tenure, tech support access, and pricing — and used them to build a risk-scoring model that reliably distinguishes high-risk customers from low-risk ones (a 7.6x difference in actual churn rates between tiers). Roughly **$263,837 in Monthly Recurring Revenue** currently sits with customers in elevated-risk segments. Given the strength of these findings, this memo recommends a low-cost, low-risk **pilot** of an automated churn-risk detection system — rather than a full build — to validate that the model changes outcomes in practice before further investment.

---

## What We Found

Analysis of 7,043 CloudSuite customer records identified four statistically significant drivers of customer churn.

**Contract type** emerged as the strongest predictor: customers on month-to-month contracts churn at a rate of 42.71%, compared to 2.83% for customers on two-year contracts — a 15-fold difference.

**Tenure** shows a consistent inverse relationship with churn risk. Customers within their first 12 months churn at 47.44%, declining steadily to 9.51% among customers with four or more years of tenure.

**Tech support access** is similarly correlated with retention. Customers without tech support churn at 41.64%, nearly three times the rate observed among customers with tech support (15.17%).

**Monthly charges** exhibit a non-linear relationship with churn, peaking in the $65–$95 range (35.94%) rather than at the highest price tier. This suggests that perceived value, rather than price alone, is a more accurate predictor of churn risk.

A composite risk-scoring model incorporating these drivers was tested and validated against actual churn outcomes. High-Risk customers churned at 51.35%, compared to 6.75% among Low-Risk customers — a 7.6-fold difference, confirming the model's predictive validity. High- and Medium-Risk tiers together represent approximately **$263,837 in Monthly Recurring Revenue** exposed to elevated churn risk.

---

## Feasibility Assessment

**Yes, this is feasible to build.** The data needed already exists in CloudSuite's systems — no new data collection required.

**How it would work:** The current model is simple and rule-based (not AI/machine learning) — it assigns risk points based on contract type, tenure, tech support, and pricing. This makes it easy to explain to any stakeholder and cheap to build. A more advanced model could come later, but isn't needed to get started.

**Where it should live:** To be useful, risk scores need to show up where the Customer Success team already works — ideally inside their CRM, not as a separate report nobody checks.

**What it would take:** One person to build and maintain the scoring system, plus input from Customer Success on what actions to take for each risk level (e.g., "High Risk → call within 48 hours").

---

## Recommendation

**Recommendation: Worth piloting, with a phased, low-risk approach.**

The analysis shows a clear, validated relationship between a few key customer attributes and churn risk. This is a promising foundation for an automated system — but before committing to a full build, CloudSuite should validate that the model holds up in practice and that Customer Success teams will actually act on it.

**Suggested approach — validate before investing further:**

1. **Phase 1 (Pilot):** Share the current risk scores with Customer Success as a simple report for a defined trial period (e.g., 60–90 days). Track whether flagged "High Risk" customers who receive outreach churn less than those who don't.
2. **Phase 2 (Integrate, if the pilot works):** If the pilot shows the model helps reduce churn, connect risk scores into the CRM so they're visible where the team already works.
3. **Phase 3 (Improve, if scale justifies it):** Consider a more advanced model only once the simple version has proven its value and the team has enough historical outcome data to train one.

**Why this approach:** The underlying pattern is strong, but a model that looks good on historical data doesn't always change behavior or outcomes once deployed. A short pilot is a low-cost way to confirm the model earns its keep before CloudSuite invests further in tooling or integration.

---

## Risks & Considerations

**Data quality issues found during this analysis:**
- The `TotalCharges` field had 11 blank values (new customers with no billing history yet), which required special handling during data import. A production system would need a clear rule for how to score customers with incomplete data.
- Several fields (`Churn`, `TechSupport`) were imported as True/False values rather than descriptive text, which could cause confusion or errors if not carefully documented for future users of the system.

**Bias considerations:**
- The current model relies heavily on contract type and pricing. If certain customer segments (e.g., small businesses, price-sensitive customers) are more likely to choose month-to-month contracts for legitimate reasons — not because they're at risk — the model could unfairly flag them as high-risk and trigger unnecessary retention outreach.
- Before wider rollout, CloudSuite should check whether risk scores correlate with any protected or sensitive customer characteristics, to avoid discriminatory outcomes even if unintentional.

**Privacy considerations:**
- This analysis used historical account data only — no direct customer communications, survey responses, or personal identifiers beyond a customer ID. Any future expansion of the model (e.g., adding support ticket text or call transcripts) would require a review of data privacy policies and customer consent.

**Implementation risk:**
- A risk score is only useful if Customer Success teams trust it and act on it. Without clear guidance on what to do for each risk tier, the tool risks becoming "just another report" that gets ignored.

---

## What It Would Require

If the pilot in Phase 1 proves successful, moving to full implementation would require:

**People:**
- One data analyst or engineer to automate the risk-scoring process, so it updates automatically instead of being run manually.
- One BI developer (or the same person) to maintain and improve the dashboard.
- Ongoing input from Customer Success leadership to define what actions each risk tier should trigger.

**Tools:**
- No new software purchases required for the pilot phase — the existing SQL Server database and Power BI dashboard used in this analysis can support it.
- CRM integration (Phase 2) would require coordination with whichever team manages CloudSuite's CRM platform, to determine the best way to surface risk scores there.

**Time:**
- Pilot phase: 60–90 days, mostly requiring monitoring rather than active development.
- CRM integration: dependent on CRM platform capabilities, but typically a multi-week technical effort.

**Ongoing cost:**
- Primarily the time of the analyst/developer maintaining the system — no significant new infrastructure spend expected, since the underlying tools are already in place.
