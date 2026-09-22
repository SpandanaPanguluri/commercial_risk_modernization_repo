-- Dual-Run Portfolio Net Written Premium Reconciliation Summary
SELECT 
    COALESCE(l.lob_code, m.lob_code) AS line_of_business,
    COUNT(DISTINCT COALESCE(l.policy_number, m.policy_number)) AS total_policies_compared,
    SUM(l.legacy_nwp) AS total_legacy_nwp,
    SUM(m.modern_nwp) AS total_modern_nwp,
    SUM(m.modern_nwp) - SUM(l.legacy_nwp) AS portfolio_net_delta,
    CASE 
        WHEN ABS(SUM(m.modern_nwp) - SUM(l.legacy_nwp)) < 1.00 THEN 'MATCH'
        ELSE 'REVIEW_REQUIRED'
    END AS reconciliation_status
FROM (
    SELECT policy_number, line_of_business_code AS lob_code, SUM(net_written_premium_amt) AS legacy_nwp
    FROM bronze_legacy_policy_tx GROUP BY policy_number, line_of_business_code
) l
FULL OUTER JOIN (
    SELECT p.policy_number, l.lob_code, SUM(t.net_written_premium_amt) AS modern_nwp
    FROM silver_modern_policy_fact t
    JOIN silver_modern_policy_dim p ON t.policy_key = p.policy_key
    JOIN silver_modern_lob_dim l ON t.lob_key = l.lob_key
    GROUP BY p.policy_number, l.lob_code
) m ON l.policy_number = m.policy_number AND l.lob_code = m.lob_code
GROUP BY COALESCE(l.lob_code, m.lob_code)
ORDER BY portfolio_net_delta DESC;
