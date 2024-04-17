SELECT A.customer_id,
	ISNULL(COUNT(DISTINCT B.order_date), 0) visits
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
GROUP BY A.customer_id
ORDER BY 2 DESC;
