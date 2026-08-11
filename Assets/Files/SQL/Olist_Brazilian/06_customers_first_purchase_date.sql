SELECT
	customer_unique_id,
	MIN(order_purchase_timestamp) AS first_purchase_date
FROM customers c
JOIN orders_dataset od
	ON c.customer_id = od.customer_id
GROUP BY customer_unique_id