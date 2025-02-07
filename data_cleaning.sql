-- 1. Create backup table
CREATE TABLE IF NOT EXISTS product_detail_backup AS 
SELECT * FROM transactions;

-- 2. Initial Data Quality Checks
SELECT 
    COUNT(*) as total_rows,
    COUNT(*) FILTER (WHERE transaction_id IS NULL) as null_trans_ids,
    COUNT(*) FILTER (WHERE unit_price IS NULL) as null_prices,
    COUNT(*) FILTER (WHERE transaction_qty IS NULL) as null_quantities,
    COUNT(*) FILTER (WHERE product_category IS NULL) as null_categories,
    COUNT(*) FILTER (WHERE product_type IS NULL) as null_types,
    COUNT(*) FILTER (WHERE product_detail IS NULL) as null_details,
    COUNT(*) FILTER (WHERE store_id IS NULL) as null_store_ids,
    COUNT(*) FILTER (WHERE store_location IS NULL) as null_locations
FROM transactions;

-- 3. Fix Product Name Inconsistencies
CREATE TABLE IF NOT EXISTS product_name_corrections (
    original_name VARCHAR(100),
    corrected_name VARCHAR(100)
);

INSERT INTO product_name_corrections VALUES
    ('Scottish Cream Scone ', 'Scottish Cream Scone'),
    ('Jamacian Coffee River', 'Jamaican Coffee River'),
    ('Carmel syrup', 'Caramel syrup');

UPDATE transactions 
SET product_detail = pnc.corrected_name
FROM product_name_corrections pnc
WHERE TRIM(transactions.product_detail) = pnc.original_name;

-- 4. Standardize Size Notations
UPDATE transactions
SET product_detail = 
    CASE 
        WHEN product_detail LIKE '% Lg' THEN REPLACE(product_detail, ' Lg', ' Large')
        WHEN product_detail LIKE '% Rg' THEN REPLACE(product_detail, ' Rg', ' Regular')
        WHEN product_detail LIKE '% Sm' THEN REPLACE(product_detail, ' Sm', ' Small')
        ELSE product_detail
    END;

-- 5. Fix Price Anomalies
UPDATE transactions SET unit_price = 12.00 
WHERE product_detail = 'I Need My Bean! Diner mug';

UPDATE transactions SET unit_price = 14.00 
WHERE product_detail = 'I Need My Bean! Latte cup';

UPDATE transactions SET unit_price = 22.50 
WHERE product_detail = 'Organic Decaf Blend';

-- 6. Final Verification Queries
SELECT 
    COUNT(*) as total_transactions,
    COUNT(DISTINCT product_detail) as unique_products,
    COUNT(DISTINCT store_location) as store_count,
    COUNT(DISTINCT transaction_date) as operating_days,
    SUM(CASE WHEN unit_price <= 0 THEN 1 ELSE 0 END) as zero_price_count,
    SUM(CASE WHEN transaction_qty <= 0 THEN 1 ELSE 0 END) as zero_qty_count
FROM transactions;
