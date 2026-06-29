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
