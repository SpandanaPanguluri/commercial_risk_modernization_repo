# Forensic Findings Report: Legacy P&C to Cloud Modernization
**Author:** Business Data Analyst  
**Target:** Old Republic Commercial Risk (PMA Legacy Modernization)  

## Executive Summary
Profiling multi-line commercial policy/endorsement extracts revealed a **2.84% net written premium (NWP) skew** across mid-term retro-rate endorsements (`TRAN_TYPE = 'RETRO'`). Root cause stems from legacy flat-file timestamp truncation combined with additive sequence duplication on adjustments.

## Key Findings Breakdown

| Finding ID | Domain / LOB | Root Cause Description | Financial / Operational Impact | Remediation Action |
| :--- | :--- | :--- | :--- | :--- |
| **F-01** | Commercial Auto / WC | Null effective time stamps on retro endorsements default to UTC midnight, skewing window partition sequence order. | $14,250 net monthly variance on portfolio financial reconciliation reports. | Enforce `COALESCE(CAST(EFF_DT AS DATE), INCEPTION_DT)` + deterministic sequence partition key. |
| **F-02** | General Liability | Sub-limit endorsement sign codes stored as text sign flags rather than signed numeric factors. | Overstatement of retroactive exposure credits by ~1.4% in legacy extraction scripts. | Map sign multiplier rule in Bronze-to-Silver ADF transformation mapping (STM). |
| **F-03** | Dual-State Operations | Disjoint cutover timelines leave Workers' Comp modern and Commercial Auto legacy-bound. | Reporting blind spots in executive multi-LOB cross-sell views. | Deploy unified Power BI semantic union view with interim override log. |

## Recommended Next Steps
1. Push STM rule `BR-04` (`RETRO` sign multiplier) to Sprint 5 ADF data engineering backlog.
2. Publish `sql/reconciliation_variance.sql` view into Fabric Gold semantic model for daily automated Slack/Teams variance alerts (> $50 threshold).
