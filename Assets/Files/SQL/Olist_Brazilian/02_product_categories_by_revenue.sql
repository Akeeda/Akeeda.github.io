SELECT
	product_category_name_english,
	SUM(price) as revenue
FROM product_category_name pcn
JOIN products_dataset pd
	ON pcn.product_category_name = pd.product_category_name
JOIN orders_items oi
	ON pd.product_id = oi.product_id
JOIN orders_dataset od
	ON oi.order_id = od.order_id
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;