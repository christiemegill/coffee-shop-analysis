WITH price_changes AS (
    SELECT 
        price_trans.product_detail,
        price_trans.transaction_date,
        price_trans.unit_price as new_price,
        LAG(price_trans.unit_price) OVER (
            PARTITION BY price_trans.product_detail 
            ORDER BY price_trans.transaction_date
        ) as previous_price,
        price_trans.transaction_qty,
        ROUND(
            ((price_trans.unit_price - LAG(price_trans.unit_price) OVER (
                PARTITION BY price_trans.product_detail 
                ORDER BY price_trans.transaction_date
            )) / LAG(price_trans.unit_price) OVER (
                PARTITION BY price_trans.product_detail 
                ORDER BY price_trans.transaction_date
            ) * 100)::numeric, 2
        ) as price_change_percent
    FROM transactions price_trans
)
SELECT 
    product_detail,
    transaction_date,
    previous_price,
    new_price,
    price_change_percent,
    transaction_qty as volume_after_change,
    LAG(transaction_qty) OVER (
        PARTITION BY product_detail 
        ORDER BY transaction_date
    ) as volume_before_change
FROM price_changes
WHERE price_change_percent IS NOT NULL
ORDER BY ABS(price_change_percent) DESC;
