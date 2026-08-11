SELECT
    c.customer_unique_id,
    SUM(oi.price) AS total_spend
FROM customers c
JOIN orders_dataset od
    ON c.customer_id = od.customer_id
JOIN orders_items oi
    ON od.order_id = oi.order_id
WHERE od.order_status = 'delivered'
GROUP BY c.customer_unique_id
ORDER BY total_spend DESC;