SELECT TOP 1 A.product_name,
COUNT(B.product_id) times_ordered
FROM case01.menu A
LEFT JOIN case01.sales B
	ON A.product_id=B.product_id
GROUP BY A.product_name
ORDER BY times_ordered DESC;
