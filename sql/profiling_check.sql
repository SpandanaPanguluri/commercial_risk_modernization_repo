-- BA Profiling Query: Identifying Endorsement Transaction Duplication or Mismatched Net Written Premium
WITH legacy_agg AS (
    SELECT 
        policy_number,
        line_of_business_code,
        COUNT(DISTINCT transaction_id) as legacy_tx_count,
        SUM(net_written_premium_amt) as legacy_nwp
    FROM bronze_legacy_policy_tx
    WHERE accounting_date >= '2025-01-01'
    GROUP BY policy_number, line_of_business_code
),
modern_agg AS (
    SELECT 
        p.policy_number,
        l.lob_code as line_of_business_code,
        COUNT(DISTINCT t.transaction_id) as modern_tx_count,
        SUM(t.net_written_premium_amt) as modern_nwp
    FROM silver_modern_policy_fact t
    JOIN silver_modern_policy_dim p ON t.policy_key = p.policy_key
    JOIN silver_modern_lob_dim l ON t.lob_key = l.lob_key
    WHERE t.accounting_date >= '2025-01-01'
    GROUP BY p.policy_number, l.lob_code
)
SELECT 
    COALESCE(l.policy_number, m.policy_number) as policy_number,
    COALESCE(l.line_of_business_code, m.line_of_business_code) as lob,
    l.legacy_nwp,
    m.modern_nwp,
    COALESCE(m.modern_nwp, 0) - COALESCE(l.legacy_nwp, 0) as nwp_variance,
    l.legacy_tx_count,
    m.modern_tx_count
FROM legacy_agg l
FULL OUTER JOIN modern_agg m 
    ON l.policy_number = m.policy_number 
   AND l.line_of_business_code = m.line_of_business_code
WHERE ABS(COALESCE(m.modern_nwp, 0) - COALESCE(l.legacy_nwp, 0)) > 0.01;
