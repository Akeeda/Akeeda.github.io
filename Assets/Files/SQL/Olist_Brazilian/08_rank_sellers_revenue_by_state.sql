WITH seller_revenue AS (
	SELECT
		sd.seller_id,
		sd.seller_state,
		SUM(oi.price) AS revenue
	FROM sellers_dataset sd
	JOIN orders_items oi
		ON sd.seller_id = oi.seller_id
	JOIN orders_dataset od
		ON oi.order_id = od.order_id
	WHERE order_status = 'delivered'
	GROUP BY 1, 2
)
SELECT *,
	RANK() OVER (
		PARTITION BY seller_state
		ORDER BY revenue DESC
	) AS revenue_rank
FROM seller_revenue