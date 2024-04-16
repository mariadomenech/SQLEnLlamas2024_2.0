SELECT 
	customers.customer_id,
	COUNT(distinct sales.order_date) AS NUM_VISITAS
FROM 
	case01.customers customers
LEFT JOIN 
	case01.sales sales 
	ON (customers.customer_id = sales.customer_id)
GROUP BY
	customers.customer_id
ORDER BY
	CUSTOMER_ID ASC;
-- Según SQL Query Comparison Tool el orden sería así, pero vería más lógico mostrar el orden según el número de visitas :)
