SELECT
	SUM(price) AS total_revenue
FROM orders_items oi
JOIN orders_dataset od
	ON oi.order_id = od.order_id
WHERE order_status = 'delivered';