#Commercial Risk (Legacy Systems) — Cloud Modernization BDA Portfolio

End-to-end GitHub repository demonstrating **Business Data Analyst (BDA)** deliverables bridging legacy commercial P&C policy/endorsement extracts to modern cloud architectures (Microsoft Fabric / Snowflake / ADF).

## Repository Structure
```
├── README.md
├── .gitignore
├── data/
│   ├── bronze_legacy_policy_tx.csv      # Raw legacy flat-file policy/endorsement extract
│   ├── silver_modern_policy_fact.fact   # Modernized star-schema fact table sample
│   ├── silver_modern_policy_dim.csv     # Policy dimension table
│   └── silver_modern_lob_dim.csv        # Line of Business dimension table
├── visualizations/
│   └── nwp_variance_by_lob.png          # Power BI / Executive readout chart
├── docs/
│   ├── stm_policy_txn.md                # Source-to-Target Mapping & BRs
│   ├── interim_workflow_runbook.md      # Dual-state operational runbook
│   ├── findings_report.md               # Forensic data audit findings report
│   └── powerbi_semantic_model.md        # Star schema, DAX measures & canvas layout spec
└── sql/
    ├── profiling_check.sql              # Current-state anomaly/null profiling
    └── reconciliation_variance.sql      # Dual-run NWP variance reconciliation
```

## Quick Start
1. Review forensic audit findings in `docs/findings_report.md`.
2. Inspect source-to-target specs in `docs/stm_policy_txn.md`.
3. Query `sql/reconciliation_variance.sql` to validate dual-run portfolio sign parity.
