WITH delivery_reviews AS (
  SELECT
        review_score,
        DATE_PART('day', order_delivered_customer_date - order_purchase_timestamp) AS delivery_days
    FROM orders_dataset od
    JOIN order_reviews r
        ON od.order_id = r.order_id
    WHERE order_status = 'delivered'
),
fast_delivery_reviews AS (
	SELECT
		review_score,
		CASE
    WHEN delivery_days <= 2 THEN '0–2 days'
    WHEN delivery_days <= 5 THEN '3–5 days'
    WHEN delivery_days <= 10 THEN '6–10 days'
    WHEN delivery_days <= 14 THEN '11–14 days'
    WHEN delivery_days <= 21 THEN '15–21 days'
    WHEN delivery_days <= 28 THEN '22–28 days'
    ELSE '29+ days'
	   END AS delivery_days_buckets
	FROM delivery_reviews
)
SELECT
	delivery_days_buckets,
	COUNT(*) AS total_orders,
	ROUND(AVG(review_score), 2) AS average_review
FROM fast_delivery_reviews
GROUP BY delivery_days_buckets
ORDER BY average_review desc;




