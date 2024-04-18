-- ¿Cuál es el producto más pedido del menú y cuántas veces ha sido pedido?

/*Solución 1: 	en este caso aunque tengamos que hacer una subselect nos aseguramos que obtenemos todos los productos
				a pesar de que tengan el mismo número de ventas. Es la opción que propongo: */
SELECT 
	base.product_name
	, base.num_ventas
FROM
(
	SELECT 
		 menu.product_name
		, COUNT(sales.customer_id) AS num_ventas
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
		ON menu.product_id = sales.product_id
	GROUP BY  menu.product_name
) base
WHERE 
	base.num_ventas = (	SELECT top 1 COUNT(customer_id) AS num_ventas
							FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales 
							GROUP BY product_id
							ORDER BY 1 DESC
						)
;

/*Solución 2: 	para el caso que tenemos la respuesta es correcta en ambos casos, pero con esto no nos aseguramos 
				que dos productos tengan el mismo número de ventas, por lo que solo mostraría uno de ellos. Alternativas: */
-- Opción 2-1:
SELECT top 1
	 menu.product_name
	, COUNT(sales.customer_id) AS num_ventas
FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
	ON menu.product_id = sales.product_id
GROUP BY  menu.product_name
ORDER BY 2 DESC;

-- Opción 2-2:
SELECT 
	base.product_name
	, base.num_ventas
FROM
(
	SELECT 
		 menu.product_name
		, COUNT(sales.customer_id) AS num_ventas
		,RANK() OVER( ORDER BY COUNT(sales.customer_id) DESC) AS ventas
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
		ON menu.product_id = sales.product_id
	GROUP BY  menu.product_name
) base
WHERE ventas=1;
