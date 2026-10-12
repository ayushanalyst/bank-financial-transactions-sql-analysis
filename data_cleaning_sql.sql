-- =========================================================
-- PROJECT: BANK FINANCIAL TRANSACTIONS ANALYSIS
-- SCRIPT 02: EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================================

USE bank_db;


-- =========================================================
-- 1. OVERALL TRANSACTION KPIs
-- =========================================================

SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT client_id) AS unique_customers,
    COUNT(DISTINCT card_id) AS unique_cards,

    ROUND(
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END), 2
    ) AS gross_transaction_value,

    ROUND(
        SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END), 2
    ) AS negative_transaction_value,

    ROUND(SUM(amount), 2) AS net_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value,
    ROUND(MIN(amount), 2) AS minimum_transaction,
    ROUND(MAX(amount), 2) AS maximum_transaction
FROM transactions_data;


-- =========================================================
-- 2. POSITIVE, NEGATIVE AND ZERO TRANSACTION COUNTS
-- =========================================================

SELECT
    CASE
        WHEN amount > 0 THEN 'Positive'
        WHEN amount < 0 THEN 'Negative'
        ELSE 'Zero'
    END AS transaction_category,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS transaction_value,
    ROUND(AVG(amount), 2) AS average_amount
FROM transactions_data
GROUP BY transaction_category
ORDER BY total_transactions DESC;


-- =========================================================
-- 3. NEGATIVE TRANSACTION ANALYSIS
-- =========================================================

SELECT
    COUNT(*) AS negative_transactions,
    ROUND(SUM(amount), 2) AS total_negative_value,
    ROUND(AVG(amount), 2) AS average_negative_transaction,
    ROUND(MIN(amount), 2) AS largest_negative_transaction,
    ROUND(MAX(amount), 2) AS smallest_negative_transaction
FROM transactions_data
WHERE amount < 0;


-- =========================================================
-- 4. NEGATIVE TRANSACTIONS BY PAYMENT METHOD
-- =========================================================

SELECT
    use_chip,
    COUNT(*) AS negative_transactions,
    ROUND(SUM(amount), 2) AS total_negative_value,
    ROUND(AVG(amount), 2) AS average_negative_value
FROM transactions_data
WHERE amount < 0
GROUP BY use_chip
ORDER BY total_negative_value;


-- =========================================================
-- 5. TOP 10 MERCHANTS BY NEGATIVE TRANSACTION VALUE
-- =========================================================

SELECT
    merchant_id,
    COUNT(*) AS negative_transactions,
    ROUND(SUM(amount), 2) AS total_negative_value,
    ROUND(AVG(amount), 2) AS average_negative_value
FROM transactions_data
WHERE amount < 0
GROUP BY merchant_id
ORDER BY total_negative_value ASC
LIMIT 10;


-- =========================================================
-- 6. MERCHANT NEGATIVE-TRANSACTION RATE
-- Exclude merchants with fewer than 20 transactions.
-- =========================================================

SELECT
    merchant_id,
    COUNT(*) AS total_transactions,

    SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END)
        AS negative_transactions,

    ROUND(
        100.0 * SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS negative_transaction_rate,

    ROUND(SUM(amount), 2) AS net_transaction_value
FROM transactions_data
GROUP BY merchant_id
HAVING COUNT(*) >= 20
ORDER BY negative_transaction_rate DESC
LIMIT 10;


-- =========================================================
-- 7. PAYMENT METHOD ANALYSIS
-- =========================================================

SELECT
    use_chip,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS net_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value,

    ROUND(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM transactions_data), 2
    ) AS transaction_share_pct
FROM transactions_data
GROUP BY use_chip
ORDER BY total_transactions DESC;


-- =========================================================
-- 8. TRANSACTION ANALYSIS BY MERCHANT STATE
-- Exclude missing state values.
-- =========================================================

SELECT
    merchant_state,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS net_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value
FROM transactions_data
WHERE merchant_state IS NOT NULL
  AND TRIM(merchant_state) <> ''
GROUP BY merchant_state
ORDER BY net_transaction_value DESC
LIMIT 10;


-- =========================================================
-- 9. CUSTOMER PROFILE SUMMARY
-- =========================================================

SELECT
    COUNT(*) AS total_customers,
    ROUND(AVG(current_age), 2) AS average_age,
    ROUND(AVG(credit_score), 2) AS average_credit_score,
    ROUND(AVG(yearly_income), 2) AS average_yearly_income,
    ROUND(AVG(total_debt), 2) AS average_total_debt,
    ROUND(AVG(num_credit_cards), 2) AS average_cards_per_customer
FROM users_data;


-- =========================================================
-- 10. CUSTOMER DISTRIBUTION BY GENDER
-- =========================================================

SELECT
    gender,
    COUNT(*) AS total_customers,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM users_data), 2
    ) AS customer_share_pct
FROM users_data
GROUP BY gender
ORDER BY total_customers DESC;


-- =========================================================
-- 11. CUSTOMER AGE SEGMENTATION
-- =========================================================

SELECT
    CASE
        WHEN current_age BETWEEN 18 AND 24 THEN '18-24'
        WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
        WHEN current_age BETWEEN 55 AND 64 THEN '55-64'
        WHEN current_age BETWEEN 65 AND 74 THEN '65-74'
        ELSE '75+'
    END AS age_group,
    COUNT(*) AS total_customers
FROM users_data
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '18-24' THEN 1
        WHEN '25-34' THEN 2
        WHEN '35-44' THEN 3
        WHEN '45-54' THEN 4
        WHEN '55-64' THEN 5
        WHEN '65-74' THEN 6
        ELSE 7
    END;


-- =========================================================
-- 12. CUSTOMER CREDIT SCORE DISTRIBUTION
-- =========================================================

SELECT
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score < 670 THEN 'Fair'
        WHEN credit_score < 740 THEN 'Good'
        WHEN credit_score < 800 THEN 'Very Good'
        ELSE 'Excellent'
    END AS credit_score_band,
    COUNT(*) AS total_customers
FROM users_data
GROUP BY credit_score_band
ORDER BY
    CASE credit_score_band
        WHEN 'Poor' THEN 1
        WHEN 'Fair' THEN 2
        WHEN 'Good' THEN 3
        WHEN 'Very Good' THEN 4
        ELSE 5
    END;


-- =========================================================
-- 13. CUSTOMER DEBT-TO-INCOME SEGMENTATION
-- Project-defined exploratory thresholds, not formal
-- lending standards.
-- =========================================================

SELECT
    CASE
        WHEN total_debt / NULLIF(yearly_income, 0) < 1
            THEN 'Low Debt'
        WHEN total_debt / NULLIF(yearly_income, 0) < 2
            THEN 'Moderate Debt'
        WHEN total_debt / NULLIF(yearly_income, 0) < 3
            THEN 'High Debt'
        ELSE 'Very High Debt'
    END AS debt_income_band,
    COUNT(*) AS total_customers
FROM users_data
WHERE yearly_income > 0
GROUP BY debt_income_band
ORDER BY
    CASE debt_income_band
        WHEN 'Low Debt' THEN 1
        WHEN 'Moderate Debt' THEN 2
        WHEN 'High Debt' THEN 3
        ELSE 4
    END;


-- =========================================================
-- 14. TOP 10 CUSTOMERS BY NET TRANSACTION VALUE
-- =========================================================

SELECT
    t.client_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS net_transaction_value,
    ROUND(AVG(t.amount), 2) AS average_transaction_value,
    u.yearly_income,
    u.total_debt,
    u.credit_score,
    u.current_age
FROM transactions_data t
JOIN users_data u
    ON t.client_id = u.id
GROUP BY
    t.client_id,
    u.yearly_income,
    u.total_debt,
    u.credit_score,
    u.current_age
ORDER BY net_transaction_value DESC
LIMIT 10;


-- =========================================================
-- 15. CUSTOMER TRANSACTION VALUE AS % OF ANNUAL INCOME
-- Excludes customers with non-positive net transaction
-- values. Review unusually low incomes before interpreting.
-- =========================================================

SELECT
    t.client_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS net_transaction_value,
    u.yearly_income,
    u.total_debt,
    u.credit_score,

    ROUND(
        100.0 * SUM(t.amount) / NULLIF(u.yearly_income, 0), 2
    ) AS txn_value_pct_of_income

FROM transactions_data t
JOIN users_data u
    ON t.client_id = u.id
GROUP BY
    t.client_id,
    u.yearly_income,
    u.total_debt,
    u.credit_score
HAVING SUM(t.amount) > 0
ORDER BY txn_value_pct_of_income DESC
LIMIT 10;


-- =========================================================
-- 16. MONTHLY TRANSACTION SUMMARY
-- =========================================================

SELECT
    DATE_FORMAT(date, '%Y-%m') AS txn_month,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS net_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value
FROM transactions_data
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY txn_month;


-- =========================================================
-- 17. DAILY TRANSACTION SUMMARY
-- =========================================================

SELECT
    DATE(date) AS txn_date,
    COUNT(*) AS total_transactions,
    ROUND(SUM(amount), 2) AS net_transaction_value,
    ROUND(AVG(amount), 2) AS average_transaction_value
FROM transactions_data
GROUP BY DATE(date)
ORDER BY txn_date;


-- =========================================================
-- END OF EXPLORATORY ANALYSIS
-- =========================================================