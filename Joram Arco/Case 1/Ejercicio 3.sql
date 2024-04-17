SELECT
	cliente,
	COALESCE(STRING_AGG(product_name, ','),' ') as productos
FROM (
	SELECT
		DISTINCT customers.customer_id as cliente,
		menu.product_name,
		sales.order_date,
		RANK() OVER(PARTITION BY customers.customer_id ORDER BY sales.order_date) as ranking
	FROM
		case01.customers customers
	LEFT JOIN
		case01.sales sales
	ON
		(customers.customer_id = sales.customer_id)
	LEFT JOIN
		case01.menu
	ON
		(sales.product_id = menu.product_id)
) as CONSULTA
WHERE
	ranking = 1
GROUP BY 
	cliente
