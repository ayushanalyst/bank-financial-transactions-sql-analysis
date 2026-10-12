# Bank Financial Transactions Analysis Using SQL

## Project Overview

This project uses **MySQL to analyze financial transactions, customer profiles, and card data** to uncover transaction patterns, customer spending behavior, merchant activity, and daily transaction trends.

The project demonstrates practical SQL skills, including data cleaning, exploratory data analysis (EDA), joins, Common Table Expressions (CTEs), aggregate functions, and window functions.

The goal is to transform raw financial data into meaningful business insights and demonstrate an end-to-end SQL analytics workflow.

## Project Objectives

- Analyze overall transaction volume and transaction value.
- Examine positive, negative, and zero-value transactions.
- Compare swipe and online payment behavior.
- Identify merchants with high negative-transaction rates.
- Analyze transaction activity across merchant states.
- Identify customers with the highest net transaction value.
- Calculate daily transaction trends and day-over-day growth.
- Combine transaction, customer, and card data using SQL joins and views.

## Tools and Technologies

- **Database:** MySQL
- **SQL Environment:** MySQL Workbench
- **Data Storage and Sample Data:** Microsoft Excel
- **Analysis Techniques:** Data Cleaning, EDA, Aggregations, Joins, CTEs, Window Functions

## Repository Structure

```text
bank-financial-transactions-sql-analysis/
│
├── 01_data_cleaning.sql
├── 02_exploratory_analysis.sql
├── 03_advanced_analysis.sql
├── financial_data_sample.xlsx
└── README.md
```

*Note: Replace `financial_data_sample.xlsx` with the actual name of your uploaded Excel workbook.*

## Dataset Description

The project uses three related datasets:

| Dataset | Description |
|---|---|
| `transactions_data` | Transaction dates, amounts, payment methods, merchant IDs, and merchant locations |
| `users_data` | Customer demographics, income, total debt, and credit scores |
| `cards_data` | Card brands, card types, credit limits, and card attributes |

### Excel Sample Workbook

The uploaded Excel workbook contains three worksheets:

- **Transactions:** 50 sample transaction records
- **Users:** 50 sample customer records
- **Cards:** 50 sample card records

These worksheets provide a small reference sample of the data structure. They are not the complete analytical dataset used for the reported SQL results.

### Analytical Dataset Scope

The SQL analysis was performed on the records successfully imported into MySQL:

| Dataset | Records |
|---|---:|
| Customer records | 2,000 |
| Card records | 2,298 |
| Transaction records | 9,047 |
| Distinct customers in transactions | 407 |
| Distinct cards in transactions | 881 |

The imported transactions cover January 1–8, 2010, with the latest recorded transaction at approximately 10:19 AM on January 8.

These figures describe the imported analytical population and should not be interpreted as the complete coverage of the original source dataset.

## SQL Analysis Performed

### 1. Data Cleaning and Validation

File: `01_data_cleaning.sql`

- Checked record counts and duplicate IDs.
- Inspected missing values and transaction date ranges.
- Validated transaction amounts and numeric data types.
- Checked relationships between customers, cards, and transactions.
- Reviewed credit limits and other financial fields.
- Retained negative and zero-value transactions for further investigation.

### 2. Exploratory Data Analysis

File: `02_exploratory_analysis.sql`

- Calculated total transactions, gross transaction value, net transaction value, and average transaction value.
- Compared positive, negative, and zero-value transactions.
- Analyzed negative transactions by payment method.
- Identified merchants with high negative-transaction values and rates.
- Examined transaction performance by merchant state.
- Explored customer demographics and financial profiles.
- Ranked customers by net transaction value.
- Analyzed daily and monthly transaction activity.

### 3. Advanced SQL Analysis

File: `03_advanced_analysis.sql`

- Created a reusable `financial_master` view joining transaction, customer, and card information.
- Used CTEs to organize complex analytical queries.
- Applied `LAG()` to calculate day-over-day transaction value growth.
- Used `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` to rank customers.
- Compared payment methods using transaction volume and value.
- Calculated merchant-level negative-transaction rates.

## Key Findings

### Overall Transaction Performance

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
- Average transaction value was **$42.29 for swipe transactions** and **$55.65 for online transactions**.

This indicates that swipe transactions dominated transaction volume, while online transactions had a higher average transaction amount.

### Negative Transaction Analysis

- A total of **502 transactions** had negative amounts.
- Their combined value was **-$46,858.00**.
- Merchant `59935` recorded 160 negative transactions totalling **-$11,840.00**.
- Negative amounts may represent refunds, reversals, or other adjustments; their exact causes were not independently confirmed.

### Geographic Analysis

California recorded the highest net transaction value among states with available location information, at **$44,665.72**.

### Daily Transaction Trends

- January 5, 2010, had the highest daily net transaction value: **$59,691.54**.
- Day-over-day growth was calculated using the `LAG()` window function.
- The apparent decline on January 8 should be interpreted cautiously because the available transactions for that day end at approximately 10:19 AM.

## SQL Skills Demonstrated

- Data cleaning and validation
- Filtering, grouping, sorting, and aggregation
- `CASE` expressions and conditional aggregation
- Primary keys, foreign keys, and joins
- Common Table Expressions (CTEs)
- Window functions: `LAG()`, `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()`
- Date functions and day-over-day growth calculations
- Creating reusable SQL views
- Translating analytical results into business insights

## Limitations

- The analysis uses the successfully imported transaction population rather than necessarily the complete original dataset.
- Transaction history covers only January 1–8, 2010.
- Negative transactions were not independently confirmed to be refunds.
- Some customer income values require further validation before drawing income-based conclusions.
- Merchant IDs were used because descriptive merchant names were not included in the selected tables.
- The Excel workbook contains only 50 sample rows per worksheet and does not reproduce the complete analytical dataset.
- The analysis is descriptive and is not a formal fraud-detection or credit-risk assessment.

## How to Reproduce the Analysis

1. Install MySQL and MySQL Workbench.
2. Create or select the `bank_db` database.
3. Import the complete available datasets into `users_data`, `cards_data`, and `transactions_data`.
4. Ensure the columns have the expected data types and the cleaning operations are completed.
5. Run `01_data_cleaning.sql` to validate the data.
6. Run `02_exploratory_analysis.sql` to reproduce the exploratory analysis.
7. Run `03_advanced_analysis.sql` to reproduce the advanced analysis and create the `financial_master` view.

The uploaded Excel workbook is provided as sample reference data; it is not a replacement for the complete datasets required to reproduce the reported results.

## Future Improvements

- Build an interactive Power BI dashboard.
- Add additional reconciliation and data-quality checks.
- Validate complete source-dataset coverage.
- Create visualizations for transaction trends, payment methods, and merchant activity.
- Expand the analysis using verified merchant descriptions and additional transaction metadata.

## Author

**Ayush Sharma**

SQL | MySQL | Data Analytics | Exploratory Data Analysis
