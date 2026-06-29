## projects/tin200-data-foundation/README.md

# TIN200 Data Foundation & Automation Layer

**Client:** Technology Investment Network (TIN), Auckland — real industry capstone
**Role:** Data Analyst, Capstone Group 5 (individual contribution described below)
**Course:** BUSINFO 718 — Applied Analytics Capstone, University of Auckland

### The problem
Each year TIN publishes the **TIN200**, the ranking of New Zealand's largest technology exporters. Investors, government agencies and the listed firms themselves rely on it — so every number has to withstand challenge. The brief: take the raw data behind the 2026 report and bring it to a standard where any single figure could be defended.

### What I did
- Validated candidate companies against TIN's inclusion criteria and built supporting datasets (cleantech, early-stage investment, export context, acquisitions, contacts).
- Validated **30 merger-and-acquisition events** against primary sources.
- Built a **Python automation pipeline that cleans the raw source files in ~30 seconds**, replacing slow manual cleaning with a reproducible process.
- Built an **analytics layer** linking the validated figures to the wider NZ economy, turning clean data into business insight.
- Flagged and quantified a governance issue (a quarter of the list is now foreign-owned) for the client to rule on.

### Tools
Python (data cleaning & automation), Excel, primary-source research.

### Result
A production-grade, repeatable cleaning process and a fully sourced data foundation handed to the client, alongside an economic analysis and reporting manual.

> 📎 Deliverables: technical white paper + automation manual. Code/sample available on request (client data is confidential).

---
---

## projects/customer-segmentation-bank/README.md

# Customer Segmentation — Bank of Twizel

**Course:** BUSINFO 700 — Analysis of Business Problems (individual)

### The problem
A bank with **9,800 customers** wanted to move from one-size-fits-all marketing to differentiated engagement. Which customers should get which strategy?

### What I did
- Applied **Two-Step clustering (log-likelihood distance)** on six activeness-related variables.
- Produced **4 statistically valid, distinct segments** and a tailored strategy for each.

### The four segments
| Segment | Share | Strategy |
|---|---|---|
| Passive & Less Active | 46.5% | Reactivation campaigns, basic digital onboarding, bundled starter products |
| Active Credit Clients | 17.7% | Loyalty/cashback rewards, credit expansion, mobile-first banking |
| High-Valued Premium | 17.5% | Dedicated advisors, VIP tiers, wealth-management upsell |
| Loan-Engaged Actives | 18.2% | Cross-sell secured cards & top-up loans, flexible repayment |

### Tools
SPSS (Two-Step cluster analysis), segmentation profiling.

### Result
Four actionable customer segments with engagement playbooks — a basis for differentiated, ROI-focused marketing.

---
---

## projects/world-happiness-data-warehouse/README.md

# World Happiness Data Warehouse

**Course:** BUSINFO 702 — Information Management (group of 4; my focus: data modelling & SQL)

### The problem
Is national happiness driven more by sustainable development or by income — and which specific development goals matter most?

### What I did
- Integrated three open datasets: **SDG Index (2000–2022)**, **World Happiness Index (2013–2023)** and **World Bank GNI (2000–2023)**.
- Designed and built a **star-schema data warehouse in SQLite**: one fact table (country-year-indicator) with four dimension tables (time, country, indicator, income).
- Implemented an **ELT process** (staging tables → transform) in DB Browser.
- Answered three research questions on the SDG↔happiness, GNI↔happiness, and SDG×GNI relationships.

### Key findings
Strong positive correlation between SDG Index and happiness; income is a dominant driver; SDG 3 (Health), SDG 8 (Decent Work) and SDG 9 (Industry & Innovation) correlate most strongly with happiness.

### Tools
SQL, SQLite, DB Browser, dimensional modelling.

### Result
A working warehouse demonstrating how open data + sound dimensional modelling produces policy-relevant insight.

---
---

## projects/ecommerce-delivery-regression/README.md

# Predicting E-Commerce Delivery Time

**Course:** BUSINFO 704 — Statistics for Business (individual)

### The problem
Can we predict the **actual delivery time** of an e-commerce order so the business can plan service levels?

### What I did
- Sampled **1,000 transactions** (reproducible seed) from March 2018 platform data.
- Built a **multiple linear regression** predicting `actual_delivery_time` from the promised time and whether delivery was within the same region.

### Results
- Pearson correlation of **0.72** between promised and actual delivery time.
- Significant predictors: promise (p < 2e-16) and same_region (p = 0.018).
- **Adjusted R² = 0.52** — the model explains just over half the variance in delivery time.

### Tools
R, tidyverse, ggplot2.

### Takeaway
Promised time is the strongest lever on actual delivery; same-region routing meaningfully reduces it.

---
---

## projects/loan-decision-logistic/README.md

# Loan Decision Prediction (Logistic Regression)

**Course:** BUSINFO 704 — Statistics for Business (individual)

### The problem
Which customer attributes drive acceptance of a **personal loan**? Useful for targeting and credit-risk assessment.

### What I did
- Modelled a binary outcome (`personal_loan` Yes/No) on **500 observations** from `bankloan.csv`.
- Predictors: Income, Family, Education, CD Account, CreditCard usage.
- Converted categoricals to factors, ensured reproducibility with a fixed seed, and visualised key relationships.

### Key findings
Higher income and existing **CD-account ownership** are strong predictors of loan uptake — customers already engaged with the bank's products are far more likely to accept.

### Tools
R (logistic regression), ggplot2.

### Takeaway
Target high-income, product-engaged customers for personal-loan offers.

---
---

## projects/fintech-investment-appraisal/README.md

# FinTech Investment Appraisal — RosterLab Global Expansion

**Course:** BUSINFO 716 — Business Analytics for FinTech (individual)

### The problem
Should **RosterLab** (a NZ AI-rostering startup) commit **NZ$10M** to a five-year expansion into global logistics? Does it create shareholder value?

### What I did
- Estimated cost of capital using **CAPM**. Since RosterLab is private, I used a listed comparable (**TechnologyOne, ASX:TNE**) and ran an **OLS regression** of monthly returns to estimate equity beta (β = 0.659, p = 0.0047).
- **Unlevered and re-levered** beta to isolate operating risk.
- Projected free cash flows over five years against a NZ$2bn market growing 2% p.a., with share rising 1%→3%.
- Ran **sensitivity analysis** on the key value drivers.

### Tools
Excel (modelling & sensitivity), regression, CAPM/DCF.

### Takeaway
A full valuation workflow — from beta estimation to NPV and risk testing — supporting a go/no-go investment decision.

---
---

## projects/powerbi-oecd-storytelling/README.md

# Power BI Data Storytelling (OECD)

**Course:** BUSINFO 703 — Data Visualisation for Business (individual)

### The problem
Build a compelling, **ethical** data story for a non-technical business audience using public OECD data.

### What I did
- Selected 3+ related OECD datasets across 5+ countries and 5+ years.
- Performed all cleaning, transformation and modelling **inside Power BI** (Power Query + DAX) — including building a relationship between previously unrelated datasets.
- Designed interactive visuals and **contrasted an ethical visualisation against a misleading one** to demonstrate visualisation ethics.

### Tools
Power BI, Power Query, DAX.

### Takeaway
End-to-end BI: from raw OECD CSVs to an interactive, honest narrative.

> The group extension (BUSINFO 703 A2) added **unsupervised machine learning in R** on a Netflix dataset, surfaced through a Power BI report for a business audience.

---
---

## projects/covid-vaccination-python/README.md

# COVID-19 Vaccination Impact on Recovery

**Course:** BUSINFO 701 — Business Analytics Tools (individual)

### The problem
Did countries that vaccinated **earlier** and **more widely** recover faster from COVID-19?

### What I did
- Integrated two global datasets: **COVID-19 World Vaccination Progress** (223 countries) and the **Clean Complete COVID Report** (187 countries).
- Wrangled and joined the data in Python to compare vaccination timing/coverage against case and death trajectories.
- Framed the findings for decision-makers (WHO, NZ Ministry of Health) — moving from reactive to proactive preparedness.

### Tools
Python, pandas.

### Takeaway
Combining distribution data with outcome data turns raw figures into evidence for fairer, faster future pandemic responses.

---
---

## projects/project-schedule-evaluation/README.md

# Project Schedule Evaluation — PredictNow AI Launch

**Course:** BUSINFO 710 — Project Management (individual consultancy report)

### The problem
PredictNow's AI forecasting tool **must launch by 2 Nov 2026** (pre–Black Friday). Is the schedule feasible without runaway cost?

### What I did
- Rebuilt the plan in **ProjectLibre** with corrected dependency logic, vendor lead times, and the NZ 2026 working calendar/holidays.
- Validated resource allocations against capacity limits and added one temporary Data Engineer to remove structural over-allocation **without extending duration**.

### Validated outputs
- Completion: **28 Oct 2026** (≈3 working days contingency)
- Duration: 139 calendar days · Labour: 9,424 hours · Cost: **$673,120** · Over-allocation: none
- Critical path identified from infrastructure assessment → model training → GPU procurement → launch.

### Tools
ProjectLibre, critical-path method, resource levelling.

### Takeaway
A feasible, cost-controlled baseline — and evidence that further acceleration adds cost for little schedule gain.
