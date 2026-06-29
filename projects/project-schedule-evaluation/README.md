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
