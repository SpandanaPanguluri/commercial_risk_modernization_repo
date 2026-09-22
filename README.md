# Commercial Risk ( Legacy) — Cloud Modernization Mini-Project

Sample GitHub repository demonstrating the role of a **Business Data Analyst (BDA)** bridging legacy commercial P&C policy/endorsement extracts to modern cloud architectures (Microsoft Fabric / Snowflake / ADF).

## Repository Structure
```
├── README.md
├── .gitignore
├── docs/
│   ├── stm_policy_txn.md               # Source-to-Target Mapping & BRs
│   └── interim_workflow_runbook.md     # Dual-state operational runbook
└── sql/
    ├── profiling_check.sql             # Current-state anomaly/null profiling
    └── reconciliation_variance.sql     # Dual-run NWP variance reconciliation
```

## Quick Start
1. Run `sql/profiling_check.sql` against your legacy bronze/silver staging environment.
2. Review mapping rules in `docs/stm_policy_txn.md` during sprint grooming with data engineers.
3. Deploy dual-run monitoring view from `sql/reconciliation_variance.sql` into Power BI / Fabric semantic layer.
