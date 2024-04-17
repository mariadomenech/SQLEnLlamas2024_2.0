-- ¿Cuál es el primer producto que ha pedido cada cliente?
SELECT
	cust.customer_id
	, COALESCE(STRING_AGG(venta.product_name, ', '), 'Sin ventas') AS product_name
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers cust
LEFT JOIN 
(
	SELECT DISTINCT
		sales.customer_id
		, menu.product_name
		, RANK() OVER( PARTITION BY sales.customer_id ORDER BY sales.order_date ASC) AS primero
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
		ON menu.product_id = sales.product_id
) venta
	ON	venta.primero = 1
	AND cust.customer_id = venta.customer_id
GROUP BY cust.customer_id
ORDER BY 1 ;
