WITH first_purchase AS (
	SELECT
		c.customer_unique_id,
		DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
	FROM customers c
	JOIN orders_dataset o
		ON c.customer_id = o.customer_id
	WHERE order_status = 'delivered'
	GROUP BY c.customer_unique_id
),
customer_orders AS (
	SELECT
		c.customer_unique_id,
		DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month
	FROM customers c
	JOIN orders_dataset o
		ON c.customer_id = o.customer_id
	WHERE order_status = 'delivered'
)
SELECT
	fp.cohort_month,
	co.order_month,
	(
	DATE_PART('year', co.order_month) - DATE_PART('year', fp.cohort_month)
	) * 12 +
	(
	DATE_PART('month', co.order_month) - DATE_PART('month', fp.cohort_month)
	) AS months_since_first,
	COUNT(DISTINCT co.customer_unique_id) AS active_customers
FROM first_purchase fp
JOIN customer_orders co
	ON fp.customer_unique_id = co.customer_unique_id
GROUP BY
	fp.cohort_month,
	co.order_month
ORDER BY
	fp.cohort_month,
	co.order_month;