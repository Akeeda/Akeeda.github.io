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
),
cohort_activity AS (
    SELECT
        fp.customer_unique_id,
        fp.cohort_month,
        (
            DATE_PART('year', co.order_month) - DATE_PART('year', fp.cohort_month)
        ) * 12 +
        (
            DATE_PART('month', co.order_month) - DATE_PART('month', fp.cohort_month)
        ) AS month_number
    FROM first_purchase fp
    JOIN customer_orders co
    ON fp.customer_unique_id = co.customer_unique_id
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_customers
    FROM cohort_activity
    WHERE month_number = 0
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    ca.month_number,
    COUNT(DISTINCT ca.customer_unique_id) AS returning_customers,
    cs.cohort_customers,
    ROUND(
        COUNT(DISTINCT ca.customer_unique_id) * 100.0 /
        cs.cohort_customers,
        2
    ) AS retention_rate
FROM cohort_activity ca
JOIN cohort_size cs
	ON ca.cohort_month = cs.cohort_month
GROUP BY
    ca.cohort_month,
    ca.month_number,
    cs.cohort_customers
ORDER BY
    ca.cohort_month,
    ca.month_number;