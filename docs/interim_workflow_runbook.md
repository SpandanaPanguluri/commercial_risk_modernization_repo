# Dual-State / Interim Workflow Runbook

## Overview
During phased cutovers by Line of Business (LOB) (e.g., Workers' Comp live on modern cloud first; Commercial Auto remaining on legacy core), business users operate in a hybrid environment.

## Interim Operational Governance
1. **Manual Override Log:** Any manual journal/endorsement in legacy core for migrated LOBs must trigger an entry in `interim_override_log` table within 24 business hours.
2. **Unified Semantic View:** Power BI financial dashboards pull via a union view:
   - Modern silver fact table for active cutover LOBs.
   - Legacy ETL shim view for legacy-bound LOBs.
3. **Daily Reconciliation Alerting:** Automated email/Teams webhook fires if aggregate NWP delta exceeds $50.00 at portfolio level.
