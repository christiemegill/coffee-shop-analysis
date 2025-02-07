-- Analysis of sales performance and product metrics

-- 1. Basic Sales Performance Analysis
WITH product_metrics AS (
    SELECT 
        product_detail,
        product_category,
        COUNT(*) as transaction_count,
        SUM(transaction_qty) as total_units,
        ROUND(AVG(unit_price), 2) as avg_price,
        ROUND(SUM(unit_price * transaction_qty), 2) as total_revenue,
        ROUND(SUM(unit_price * transaction_qty) / SUM(transaction_qty), 2) as revenue_per_unit
    FROM transactions
    GROUP BY product_detail, product_category
),
quartiles AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY total_units) as volume_quartile,
        NTILE(4) OVER (ORDER BY total_revenue) as revenue_quartile
    FROM product_metrics
)
SELECT 
    *,
    CASE 
        WHEN volume_quartile >= 3 AND revenue_quartile >= 3 THEN 'Star Performers'
        WHEN volume_quartile >= 3 AND revenue_quartile < 3 THEN 'Volume Drivers'
        WHEN volume_quartile < 3 AND revenue_quartile >= 3 THEN 'Premium Products'
        ELSE 'Niche Items'
    END as product_segment
FROM quartiles
ORDER BY total_revenue DESC;

-- 2. Revenue Analysis by Category
SELECT 
    product_category,
    COUNT(DISTINCT product_detail) as unique_products,
    ROUND(SUM(unit_price * transaction_qty), 2) as total_revenue,
    ROUND(AVG(unit_price), 2) as avg_price,
    COUNT(*) as transaction_count
FROM transactions
GROUP BY product_category
ORDER BY total_revenue DESC;
