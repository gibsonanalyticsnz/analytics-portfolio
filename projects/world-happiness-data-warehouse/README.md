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
