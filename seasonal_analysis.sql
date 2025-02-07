WITH seasonal_metrics AS (
  SELECT 
    DATE_TRUNC('month', transaction_date) as month,
    EXTRACT(QUARTER FROM transaction_date) as quarter,
    TO_CHAR(transaction_date, 'Month') as month_name,
    product_detail,
    product_category,
    COUNT(*) as transaction_count,
    SUM(transaction_qty) as total_units,
    ROUND(AVG(unit_price), 2) as avg_price,
    ROUND(SUM(unit_price * transaction_qty), 2) as total_revenue,
    CASE 
      WHEN EXTRACT(MONTH FROM transaction_date) IN (12,1,2) THEN 'Winter'
      WHEN EXTRACT(MONTH FROM transaction_date) IN (3,4,5) THEN 'Spring'
      WHEN EXTRACT(MONTH FROM transaction_date) IN (6,7,8) THEN 'Summer'
      ELSE 'Fall'
    END as season
  FROM transactions
  GROUP BY 
    1, 2, 3,
    product_detail,
    product_category,
    CASE 
      WHEN EXTRACT(MONTH FROM transaction_date) IN (12,1,2) THEN 'Winter'
      WHEN EXTRACT(MONTH FROM transaction_date) IN (3,4,5) THEN 'Spring'
      WHEN EXTRACT(MONTH FROM transaction_date) IN (6,7,8) THEN 'Summer'
      ELSE 'Fall'
    END
  ORDER BY month
)
SELECT * FROM seasonal_metrics;
