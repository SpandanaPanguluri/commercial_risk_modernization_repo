# Power BI & Semantic Model Architecture Specification

## Data Model (Star Schema)
```
[dim_policy] (1) ------ (*) [silver_modern_policy_fact] (*) ------ (1) [dim_lob]
```

## DAX Measures for Dual-Run Reconciliation
```dax
Modern NWP Total = 
CALCULATE(
    SUM(silver_modern_policy_fact[net_written_premium_amt]),
    USERELATIONSHIP(silver_modern_policy_fact[lob_key], dim_lob[lob_key])
)

Dual-Run Status Label = var delta = [Modern NWP Total] - [Legacy Baseline NWP Total]
RETURN IF(ABS(delta) < 1.00, "MATCH", "REVIEW_REQUIRED")
```

## Recommended Visual Canvas Layout (Power BI Executive Page)
1. **Top KPI Cards:** Total Modern NWP, Total Legacy Baseline NWP, Portfolio Net Delta ($), Reconciliation Health Status.
2. **Main Chart:** Clustered Column Chart (`nwp_variance_by_lob.png` native Power BI equivalent showing LOB comparison with Variance Data Labels).
3. **Drillthrough Table:** Policy-grain variance table highlighting rows where `ABS(Delta) > $0.05`.
