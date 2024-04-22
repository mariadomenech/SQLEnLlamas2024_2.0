/* Alumno: Sergio Díaz */
/* CASO 1 - Ejercicio 3: Primer producto de cada cliente */

SELECT principal.CLIENTE AS CLIENTE
	,STRING_AGG(ISNULL(UPPER(LEFT(menu.product_name, 1)) + LOWER(SUBSTRING(menu.product_name, 2, LEN(menu.product_name))), ''), ', ') AS PLATO --formateo de los platos
FROM (
	SELECT B.DES_CLIENTE AS cliente
		,A.product_id AS id_producto
	FROM (
		SELECT customers.customer_id AS des_cliente
			,sales_detail.fecha_min AS primera_fecha
		FROM case01.customers AS customers
		LEFT JOIN (
			SELECT customer_id
				,MIN(order_date) AS fecha_min
			FROM case01.sales sales
			GROUP BY customer_id
			) sales_detail ON customers.customer_id = sales_detail.customer_id
		GROUP BY customers.customer_id
			,sales_detail.fecha_min
		) B --Query para obtener min fecha por cliente
	LEFT JOIN case01.sales A ON A.customer_id = B.DES_CLIENTE --Join para obtener los productos en la primera fecha de cada cliente
		AND A.order_date = B.primera_fecha
	GROUP BY B.des_cliente
		,A.product_id
	) principal 
LEFT JOIN case01.menu --Join para obtener los nombres de los id de producto
	ON menu.product_id = principal.id_producto
GROUP BY principal.CLIENTE;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

PERFECTO! También se podría haber hecho por medio de un RANK() ordenando por la fecha de pedido.

En cuanto a las tabulaciones y salto de líneas de las condiciones ON, me resultan más legibles si les añades un salto de línea. Pero esto es personal.

Me gusta que hayas trabajado en la limpieza del resultado final con una función para poder poner la primera letra de cada palabra en mayúsculas.

*/
