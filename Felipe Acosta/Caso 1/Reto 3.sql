-- RETO 3
-- ¿Cúal es el primer producto que ha pedido cada cliente?

SELECT DISTINCT A.customer_id Cliente, COALESCE(A.product_name,'') Primer_pedido
FROM (
	SELECT C.customer_id, B.product_name,
			RANK() OVER (PARTITION BY A.customer_id ORDER BY A.order_date ASC) AS rank
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales A
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu B ON (A.product_id = B.product_id)
	RIGHT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.customers C ON (A.customer_id = C.customer_id)
	) A
WHERE A.rank= 1;