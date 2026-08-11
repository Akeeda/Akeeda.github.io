WITH order_totals AS (
    SELECT
        order_id,
        MAX(payment_installments) AS payment_installments,
        SUM(payment_value) AS total_payment
    FROM order_payments
    GROUP BY order_id
)
SELECT
    ot.payment_installments,
    ROUND(AVG(ot.total_payment), 2) AS avg_order_spend
FROM orders_dataset o
JOIN order_totals ot
    ON o.order_id = ot.order_id
WHERE o.order_status = 'delivered'
GROUP BY ot.payment_installments
ORDER BY avg_order_spend DESC;