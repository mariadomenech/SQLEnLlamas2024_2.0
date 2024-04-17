SELECT 
	customer_id
	, ISNULL(STRING_AGG(product_name, ', ') WITHIN GROUP (ORDER BY product_name ASC), '') AS product_name
FROM (
	SELECT 
		DISTINCT M.product_name AS product_name
		, RANK() OVER
			(PARTITION BY C.customer_id ORDER BY S.order_date ASC) as rnk
		, C.customer_id AS customer_id
	FROM case01.sales S
	JOIN case01.menu M
		ON S.product_id = M.product_id
	RIGHT JOIN case01.customers C
		ON S.customer_id = C.customer_id
) a WHERE rnk = 1
GROUP BY customer_id;
