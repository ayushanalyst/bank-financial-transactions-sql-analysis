-- =========================================================
-- PROJECT: BANK FINANCIAL TRANSACTIONS ANALYSIS
-- SCRIPT 03: ADVANCED SQL ANALYSIS
-- =========================================================

USE bank_db;


-- =========================================================
-- 1. CREATE A FINANCIAL MASTER VIEW
-- Combines transactions, customers and card information.
-- =========================================================

CREATE OR REPLACE VIEW financial_master AS
SELECT
    t.id AS transaction_id,
    t.date,
    t.client_id,
    t.card_id,
    t.amount,
    t.use_chip,
    t.merchant_id,
    t.merchant_city,
    t.merchant_state,
    t.zip,
    t.mcc,
    t.errors,

    u.current_age,
    u.retirement_age,
    u.birth_year,
    u.birth_month,
    u.gender,
    u.address,
    u.per_capita_income,
    u.yearly_income,
    u.total_debt,
    u.credit_score,
    u.num_credit_cards,

    c.card_brand,
    c.card_type,
    c.has_chip,
    c.num_cards_issued,
    c.credit_limit,
    c.account_open_date,
    c.year_pin_last_changed,
    c.card_on_dark_web

FROM transactions_data t
LEFT JOIN users_data u
    ON t.client_id = u.id
LEFT JOIN cards_data c
    ON t.card_id = c.id;


-- Verify the master view
SELECT COUNT(*) AS master_records
FROM financial_master;

SELECT
    COUNT(DISTINCT client_id) AS unique_customers,
    COUNT(DISTINCT card_id) AS unique_cards
FROM financial_master;


-- =========================================================
-- 2. DAILY TRANSACTION GROWTH USING CTE AND LAG()
-- =========================================================

WITH daily_summary AS (
    SELECT
        DATE(date) AS txn_date,
        COUNT(*) AS total_transactions,
        SUM(amount) AS net_transaction_value
    FROM transactions_data
    GROUP BY DATE(date)
),
daily_comparison AS (
    SELECT
        txn_date,
        total_transactions,
        net_transaction_value,

        LAG(net_transaction_value) OVER (
            ORDER BY txn_date
        ) AS previous_day_value

    FROM daily_summary
)
SELECT
    txn_date,
    total_transactions,
    ROUND(net_transaction_value, 2) AS net_transaction_value,
    ROUND(previous_day_value, 2) AS previous_day_value,

    ROUND(
        100.0 * (net_transaction_value - previous_day_value)
        / NULLIF(previous_day_value, 0), 2
    ) AS day_over_day_growth_pct

FROM daily_comparison
ORDER BY txn_date;


-- =========================================================
-- 3. RANK CUSTOMERS BY NET TRANSACTION VALUE
-- Using DENSE_RANK()
-- =========================================================

WITH customer_summary AS (
    SELECT
        client_id,
        COUNT(*) AS total_transactions,
        ROUND(SUM(amount), 2) AS net_transaction_value,
        ROUND(AVG(amount), 2) AS avg_transaction_value
    FROM transactions_data
    GROUP BY client_id
),
customer_ranking AS (
    SELECT
        client_id,
        total_transactions,
        net_transaction_value,
        avg_transaction_value,

        DENSE_RANK() OVER (
            ORDER BY net_transaction_value DESC
        ) AS customer_rank

    FROM customer_summary
)
SELECT *
FROM customer_ranking
WHERE customer_rank <= 10
ORDER BY customer_rank;


-- =========================================================
-- 4. COMPARE ROW_NUMBER(), RANK() AND DENSE_RANK()
-- =========================================================

WITH customer_summary AS (
    SELECT
        client_id,
        ROUND(SUM(amount), 2) AS net_transaction_value
    FROM transactions_data
    GROUP BY client_id
)
SELECT
    client_id,
    net_transaction_value,

    ROW_NUMBER() OVER (
        ORDER BY net_transaction_value DESC
    ) AS row_num,

    RANK() OVER (
        ORDER BY net_transaction_value DESC
    ) AS customer_rank,

    DENSE_RANK() OVER (
        ORDER BY net_transaction_value DESC
    ) AS dense_rank

FROM customer_summary
ORDER BY net_transaction_value DESC
LIMIT 20;


-- =========================================================
-- 5. CUSTOMER SPENDING AND FINANCIAL PROFILE
-- =========================================================

SELECT
    t.client_id,
    COUNT(*) AS total_transactions,
    ROUND(SUM(t.amount), 2) AS net_transaction_value,
    ROUND(AVG(t.amount), 2) AS avg_transaction_value,

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
-- 6. ADVANCED PAYMENT METHOD SUMMARY
-- =========================================================

SELECT
    use_chip,
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT client_id) AS unique_customers,

    ROUND(SUM(amount), 2) AS net_transaction_value,

    ROUND(
        SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END), 2
    ) AS gross_positive_value,

    ROUND(
        SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END), 2
    ) AS negative_transaction_value,

    ROUND(AVG(amount), 2) AS average_transaction_value

FROM transactions_data
GROUP BY use_chip
ORDER BY total_transactions DESC;


-- =========================================================
-- 7. TOP MERCHANTS BY NEGATIVE TRANSACTION RATE
-- Minimum 20 transactions to reduce small-sample distortion.
-- =========================================================

WITH merchant_summary AS (
    SELECT
        merchant_id,
        COUNT(*) AS total_transactions,

        SUM(CASE WHEN amount < 0 THEN 1 ELSE 0 END)
            AS negative_transactions,

        SUM(amount) AS net_transaction_value

    FROM transactions_data
    GROUP BY merchant_id
)
SELECT
    merchant_id,
    total_transactions,
    negative_transactions,

    ROUND(
        100.0 * negative_transactions
        / NULLIF(total_transactions, 0), 2
    ) AS negative_transaction_rate,

    ROUND(net_transaction_value, 2) AS net_transaction_value

FROM merchant_summary
WHERE total_transactions >= 20
ORDER BY negative_transaction_rate DESC
LIMIT 10;


-- =========================================================
-- 8. FINAL PROJECT KPI SUMMARY
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
    ROUND(AVG(amount), 2) AS average_transaction_value

FROM transactions_data;


-- =========================================================
-- END OF ADVANCED ANALYSIS
-- =========================================================