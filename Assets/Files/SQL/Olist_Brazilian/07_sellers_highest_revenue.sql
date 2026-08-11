SELECT
	s.seller_id,
	SUM(price) as revenue
FROM sellers_dataset s
JOIN orders_items oi
	ON s.seller_id = oi.seller_id
JOIN orders_dataset od
	ON oi.order_id = od.order_id
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;