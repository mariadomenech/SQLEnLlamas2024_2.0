/* Obtenemos la lista de las transacciones que han vendido 3 productos o más en la misma transacción */
WITH lista_productos_mas_3_transacciones AS (
    SELECT 
        txn_id
        ,STRING_AGG('- '+product_name, CHAR(10)) WITHIN GROUP (ORDER BY product_name) AS lista_productos
    FROM case04.sales sales
    JOIN case04.product_details product_details 
		ON sales.prod_id = product_details.product_id
    GROUP BY sales.txn_id
    HAVING COUNT(DISTINCT prod_id) > 2
),

/* Obtenemos las veces que se repiten, en las transacciones anteriores, la lista de los productos vendidos en las mismas */
veces_repetida AS (
	SELECT
		lista_productos
		,COUNT(*) AS num_veces_repetida
	FROM lista_productos_mas_3_transacciones
	GROUP BY lista_productos
)

/* Finalmente mostramos las veces que se repite la lista con los productos comprados más veces junto con la propia lista de productos, además
ordenamos por ranking para obtener el mayor valor (por si en algún caso se repiten obtener los duplicados) */
SELECT 
	num_veces_repetida
	,CONCAT('La combinación más repetida es: ', CHAR(10), desc_combinacion)
FROM (
	SELECT 
		RANK() OVER (ORDER BY num_veces_repetida DESC) as ranking
		,num_veces_repetida
		,lista_productos AS desc_combinacion
	FROM veces_repetida
) consulta
WHERE ranking = 1;
