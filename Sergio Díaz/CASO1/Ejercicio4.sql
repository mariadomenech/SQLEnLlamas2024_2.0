/* Alumno: Sergio Díaz */
/* CASO 1 - Ejercicio 4: Producto más vendido y veces */


SELECT UPPER(LEFT(product_name, 1)) + LOWER(SUBSTRING(product_name, 2, LEN(product_name))) AS PRODUCTO
	,veces AS N_VECES -- Formateo de la salida
FROM (
	SELECT product_name
		,COUNT(sales.product_id) AS veces
		,RANK() OVER (
			ORDER BY COUNT(sales.product_id) DESC
			) AS ranking
	FROM case01.sales sales
	JOIN case01.menu menu -- Entendemos que el plato más pedido tiene ventas, por eso no hacemos left con el menu
		ON sales.product_id = menu.product_id
	GROUP BY product_name
	) principal -- query principal para obtener las ventas de los platos y su ranking
WHERE ranking = 1 -- Filtramos para quedarnos con el primero (más vendido)
