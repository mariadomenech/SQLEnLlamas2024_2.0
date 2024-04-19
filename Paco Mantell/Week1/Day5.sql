SELECT customer_id,
	SUM(points) total_points
FROM
(SELECT A.customer_id,
	ISNULL(C.product_name, 'Nada') product,
	CASE WHEN C.product_name='shushi' THEN
		COUNT(B.product_id) * 20
	ELSE
		COUNT(B.product_id) * 20
	END points
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
LEFT JOIN case01.menu C
	ON B.product_id=C.product_id
GROUP BY A.customer_id, C.product_name) A
GROUP BY customer_id
ORDER BY total_points DESC
