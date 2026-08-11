SELECT CORR(
    DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp),
    review_score
) AS correlation
FROM orders_dataset od
JOIN order_reviews r
    ON od.order_id = r.order_id
WHERE order_status = 'delivered';



