
# Coffee Shop Data Analysis Project

## Project Overview
Analysis of transaction data from a multi-location coffee shop chain to optimize menu performance and pricing strategies.

## Data Cleaning
Creating backup tables for safety
Fixing product name inconsistencies
Standardizing size notations
Correcting price anomalies
Conducting verification queries
## Tools Used

- PostgreSQL
- VSCode with SQLTools extension
- Git for version control

## Scripts
The `sql/cleaning/` directory contains the following cleaning scripts:
- `01_initial_checks.sql`: Initial data quality assessment
- `02_name_standardization.sql`: Product name corrections
- `03_size_standardization.sql`: Size notation standardization
- `04_price_corrections.sql`: Price anomaly fixes

## Results
After cleaning:
- 149,116 total transactions
- 80 unique products
- 3 store locations
- 181 operating days
- Standardized naming conventions
- Corrected price anomalies

## Visualizations
This project includes interactive dashboards created using Plotly:
Sales Performance Dashboard
Price vs. Volume Analysis
Revenue by Category
Top 10 Products by Revenue
Sales Volume Distribution
Seasonal Analysis Dashboard
Monthly Revenue Trends
Revenue by Season
Top Products by Season
Category Performance by Season
Average Price Trends
Transaction Count by Season

## Installation & Usage

## Prerequisites
## Python dependencies
pip install pandas plotly

## License
CC0: Public Domain
