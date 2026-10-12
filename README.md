# Bank Financial Transactions Analysis Using SQL

## Project Overview

This project analyzes financial transaction data using **MySQL and SQL** to explore transaction activity, customer spending patterns, payment methods, merchant performance, and daily transaction trends.

The project demonstrates practical SQL skills through data cleaning, data validation, exploratory data analysis, joins, Common Table Expressions (CTEs), aggregate functions, and window functions.

## Business Objectives

- Evaluate overall transaction volume and net transaction value.
- Analyze positive, negative, and zero-value transactions.
- Compare swipe and online transaction behavior.
- Identify merchants with high negative-transaction rates.
- Explore transaction activity across merchant states.
- Identify customers with the highest net transaction values.
- Calculate day-over-day transaction value growth.
- Build a reusable master view combining transactions, customer profiles, and card information.

## Tools and Technologies

- **Database:** MySQL
- **SQL Environment:** MySQL Workbench
- **Data Analysis:** SQL
- **Data Modeling:** Primary keys, foreign keys, and table joins
- **Advanced SQL:** CTEs, `CASE`, `LAG()`, `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`

## Dataset

The project uses three datasets:

| Table | Description |
|---|---|
| `users_data` | Customer demographics, income, debt, and credit scores |
| `cards_data` | Card brands, card types, credit limits, and card attributes |
| `transactions_data` | Transaction dates, amounts, payment methods, merchants, and locations |

### Data Scope

The analysis uses the successfully imported records available in MySQL:

- **2,000** customer records
- **2,298** card records
- **9,047** transaction records
- **407** distinct customers represented in the imported transactions
- **881** distinct cards represented in the imported transactions

The transaction records cover January 1–8, 2010, with the latest imported transaction at approximately 10:19 AM on January 8.

These figures describe the imported data used in this project, not necessarily the complete original dataset.

## Project Structure

```text
bank-financial-transactions-sql-analysis/
│
├── 01_data_cleaning.sql
├── 02_exploratory_analysis.sql
├── 03_advanced_analysis.sql
└── README.md
```

### 1. Data Cleaning and Validation

The cleaning and validation workflow includes:

- Checking record counts and duplicate IDs.
- Inspecting missing values.
- Validating transaction amounts and date ranges.
- Checking customer, card, and transaction relationships.
- Cleaning currency-formatted numeric fields.
- Converting transaction dates and numeric columns to appropriate data types.
- Retaining negative and zero-value transactions for investigation rather than deleting them without evidence.

### 2. Exploratory Data Analysis

The exploratory analysis covers:

- Overall transaction KPIs.
- Gross positive transaction value and net transaction value.
- Negative transaction analysis.
- Transaction breakdown by payment method.
- Merchant-level negative-transaction analysis.
- Geographic analysis by merchant state.
- Customer demographic and financial summaries.
- Top customers by net transaction value.
- Daily and monthly transaction summaries.

### 3. Advanced SQL Analysis

Advanced queries demonstrate:

- Creating a reusable `financial_master` view.
- Using CTEs to structure analytical queries.
- Applying `LAG()` to calculate day-over-day transaction value growth.
- Ranking customers with `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`.
- Joining transaction data with customer financial profiles.
- Calculating merchant negative-transaction rates.

## Key Findings

The following findings were obtained from the imported transaction records.

| Metric | Result |
|---|---:|
| Total transactions | 9,047 |
| Distinct customers | 407 |
| Distinct cards | 881 |
| Gross positive transaction value | $443,564.10 |
| Negative transaction value | -$46,858.00 |
| Net transaction value | $396,706.10 |
| Average transaction amount | $43.85 |

### Payment Method Analysis

- Swipe transactions accounted for **7,988 transactions (88.29%)**.
- Online transactions accounted for **1,059 transactions (11.71%)**.
- The average transaction amount was **$42.29 for swipe transactions** and **$55.65 for online transactions**.

### Negative Transaction Analysis

- There were **502 negative transactions**, representing approximately 5.55% of all transactions.
- Their combined value was **-$46,858.00**.
- Merchant `59935` had 160 negative transactions totalling **-$11,840.00**.
- Negative transactions may represent refunds, reversals, or other adjustments; their exact cause was not confirmed.

### Geographic Analysis

Among transactions with a recorded merchant state, California had the highest net transaction value in the analyzed records, at **$44,665.72**.

### Daily Trend Analysis

- January 5, 2010, recorded the highest daily net transaction value: **$59,691.54**.
- Day-over-day growth was calculated using the `LAG()` window function.
- January 8 showed a substantial decline in recorded transaction value, but the imported data ends at approximately 10:19 AM that day. It should not be interpreted as a full-day decline.

## SQL Skills Demonstrated

- `SELECT`, `WHERE`, `GROUP BY`, and `ORDER BY`
- Aggregate functions: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, and `MAX()`
- Conditional logic using `CASE`
- Joins and referential-integrity checks
- Common Table Expressions (CTEs)
- Window functions: `LAG()`, `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`
- Date functions and day-over-day growth calculations
- Views and reusable analytical queries

## Limitations

- The analysis covers only the successfully imported records, not necessarily the entire source dataset.
- The transaction date range is limited to January 1–8, 2010.
- Negative transaction amounts were not independently verified as refunds.
- Some customer income values were unusually low and require further validation before using income-based ratios for business conclusions.
- Merchant identifiers are used instead of merchant names because descriptive merchant-name data was not included in the selected tables.
- Findings are descriptive and should not be treated as formal credit-risk or fraud assessments.

## How to Run

1. Install MySQL and MySQL Workbench.
2. Create or select the `bank_db` database.
3. Import the three datasets into `users_data`, `cards_data`, and `transactions_data`.
4. Ensure the columns have the expected data types and the currency/date cleaning steps are completed.
5. Run `01_data_cleaning.sql` to validate the data.
6. Run `02_exploratory_analysis.sql` for exploratory analysis.
7. Run `03_advanced_analysis.sql` for advanced queries and the master view.

**Important:** The historical conversion statements in the cleaning script are commented out because the project tables are already cleaned. Do not rerun those transformations blindly on cleaned columns.

## Future Improvements

- Build an interactive Power BI dashboard.
- Add additional data-quality and reconciliation checks.
- Validate the original dataset's complete transaction coverage.
- Add visualizations for daily trends, payment methods, and merchant performance.
- Expand the analysis with verified merchant descriptions and additional transaction metadata.

## Author

**Ayush Sharma**

SQL | MySQL | Data Analytics | Exploratory Data Analysis
