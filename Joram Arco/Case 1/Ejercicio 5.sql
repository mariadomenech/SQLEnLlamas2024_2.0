SELECT
	customer_id,
	COALESCE(SUM(puntos), 0) as total_chupipuntos
FROM (
	SELECT
		customers.customer_id,
		CASE WHEN sales.product_id = 1 THEN menu.price * 20 --Tambien se puede usar product_name = 'sushi' por si en algún momento cambia la ID, pero no sería lo ideal por buscar por literal en lugar de numérico
		WHEN sales.product_id in (2,3) THEN menu.price * 10
		ELSE 0 --Se puede poner por si hay nuevos productos que no están incluidos en los puntos, o como valor por defecto en caso de no estar en los anteriores, o para evitar el NULL
		END AS puntos
	FROM case01.sales sales
	JOIN case01.menu menu
	ON (sales.product_id = menu.product_id)
	RIGHT JOIN case01.customers customers
	ON (sales.customer_id = customers.customer_id)
	) consulta
GROUP BY customer_id
ORDER BY total_chupipuntos DESC;


/* Otra forma de obtener el mismo resultado con menor código */
SELECT
	customers.customer_id,
	COALESCE(SUM(menu.price * CASE WHEN sales.product_id = 1 THEN 20 ELSE 10 end), 0) as total_chupipuntos
FROM case01.sales sales
JOIN case01.menu menu
ON (sales.product_id = menu.product_id)
RIGHT JOIN case01.customers customers
ON (sales.customer_id = customers.customer_id)
GROUP BY customers.customer_id
ORDER BY total_chupipuntos DESC;

/*COMENTARIOS JUANPE
TODO CORRECTO. Me gusta ambas opciones una algrano y la otra teniendo en cuenta que estás teniendo en cuenta otros posibles casos con el else 0 como bien comentas y me gusta también que uses el id en lugar del literal numérico pues los campos char mp siempre es lo mejor.
*/
