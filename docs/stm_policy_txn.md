# Source-to-Target Mapping (STM): Policy & Endorsement Grain

**Domain:** Commercial P&C Insurance (Workers' Comp / Commercial Auto / General Liability)  
**Target Architecture:** Silver / Gold Star Schema (Snowflake / Microsoft Fabric)  
**Author:** Business Data Analyst  

## Mapping Table

| Source Entity / Field (Legacy Core) | Data Type | Transformation / Business Rule (BR) | Target Entity / Field (Modern Silver) | Edge Case / Null Handling |
| :--- | :--- | :--- | :--- | :--- |
| `POLICY_HIST.POL_NUM` | VARCHAR(20) | Trim whitespace, uppercase | `dim_policy.policy_number` | Strict inner join; drop orphan tx |
| `ENDORS_LOG.TRAN_TYPE` | VARCHAR(10) | Map codes: `RETRO`->`ADJUST`, `NEW`->`ORIG`, `CANC`->`TERM` | `fact_policy_txn.transaction_type_code` | If null/unknown, flag as `UNCLASSIFIED_ADJ` |
| `ENDORS_LOG.EFF_DT` | DATE | Cast to UTC midnight; fallback to `POLICY_MASTER.INCEPTION_DT` if null | `fact_policy_txn.effective_date_key` | `COALESCE(CAST(EFF_DT AS DATE), INCEPTION_DT)` |
| `ENDORS_LOG.NET_PREM` | DECIMAL(18,2) | If `TRAN_TYPE = 'RETRO'`, multiply by sign indicator of adjustment sequence | `fact_policy_txn.net_written_premium_amt` | `COALESCE(NET_PREM, 0.00)` |

## Business Rules & Notes
1. **Retro Endorsement Sequencing:** Mid-term retro endorsements (`RETRO`) lacking timestamp ordering must partition by `policy_number, coverage_code, eff_dt` descending order.
2. **Dual-Run Tolerance:** Variance tolerance between legacy financial general ledger extraction and modern silver fact sum must be `< $0.05` per policy-line grain.
