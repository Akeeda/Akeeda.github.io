WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', od.order_purchase_timestamp) AS month,
        SUM(oi.price ) AS revenue
    FROM orders_dataset od
    JOIN orders_items oi
        ON od.order_id = oi.order_id
    WHERE od.order_status = 'delivered'
    GROUP BY 1
),
revenue_metrics AS (
	SELECT
		month,
		revenue,
		LAG(revenue) over (ORDER BY month) AS previous_revenue
	FROM monthly_revenue
)
SELECT
    month,
    revenue,
    revenue - previous_revenue AS absolute_mom_change,
    ROUND(
        ((revenue - previous_revenue)/ Nullif(previous_revenue, 0)) * 100,
        2
    ) AS mom_growth_rate_pct
FROM revenue_metrics
ORDER BY month;