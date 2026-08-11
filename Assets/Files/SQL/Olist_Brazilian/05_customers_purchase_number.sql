WITH purchases AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS purchase_number
    FROM customers c
    JOIN orders_dataset o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT
    purchase_number,
    COUNT(*) AS customers
FROM purchases
GROUP BY purchase_number
ORDER BY purchase_number;