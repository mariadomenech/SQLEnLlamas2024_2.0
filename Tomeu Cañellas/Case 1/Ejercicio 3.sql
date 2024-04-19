--CASO 1: Ejercicio 3
SELECT  part.customer_id,
	STRING_AGG(ISNULL(menu.product_name, 'none'), ', ') AS first_order -- Agregamos los productos de un mismo pedido y sustituimos por 'none' los valores nulos
FROM (
	-- Creamos una subconsulta 'part' con agrupaciones por cliente, cada una ordenada por fecha de pedido de forma ascendente
	SELECT DISTINCT customers.customer_id AS customer_id,
			sales.product_id AS product_id,
			RANK() OVER (PARTITION BY customers.customer_id ORDER BY sales.order_date ASC) AS ranking
	FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] customers
	LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
		ON customers.customer_id = sales.customer_id
) part
-- Usamos LEFT JOIN para obtener los nombre de los productos de la tabla 'menu'
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] menu
	ON part.product_id = menu.product_id
WHERE part.ranking = 1 -- Filtramos solo los primeros pedidos de cada cliente en la subconsulta 'part'
GROUP BY part.customer_id;

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto, el uso del STRING_AGG, el tratamiento de nulos y la limpieza.
Personalmente prefiero el uso de CTEs a subconsultas, pero es totalmente subjetivo, y en casos sencillos como este la legibilidad es la misma
pero lo dicho, sigue estando igual de bien.
Ánimo con el siguiente! :)

*/
