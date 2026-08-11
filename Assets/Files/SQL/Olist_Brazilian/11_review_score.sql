SELECT
    category,
    ROUND(AVG(review_score), 2) AS average_score
FROM (
    SELECT DISTINCT
        oi.order_id,
        pcn.product_category_name_english AS category,
        r.review_score
    FROM products_dataset pd
    JOIN product_category_name pcn
        ON pd.product_category_name = pcn.product_category_name
    JOIN orders_items oi
        ON pd.product_id = oi.product_id
    JOIN order_reviews r
        ON oi.order_id = r.order_id
) t
GROUP BY category
ORDER BY average_score DESC;


