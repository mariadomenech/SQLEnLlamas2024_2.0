/*¿Cuál es la combinación de productos distintos más repetida en una sola transacción? 
La combinación debe ser de al menos 3 productos distintos*/

SELECT TOP 1 WITH TIES COUNT(des_nombre_producto) AS num_repeticiones
	,CONCAT ('La combinacion más repetida es : ', des_nombre_producto) AS des_nombre_producto 
FROM
(
	SELECT venta.txn_id AS id_transaccion
	, STRING_AGG(producto.product_name + ' |', CHAR(10)) WITHIN GROUP (ORDER BY producto.product_name) AS des_nombre_producto
	FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales venta
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details producto
		ON venta.prod_id = producto.product_id
	GROUP BY venta.txn_id
	HAVING COUNT(*) >= 3
) BASE
GROUP BY des_nombre_producto
ORDER BY 1 DESC

-- Se puede hacer sepación con - o con cualquier otro, me gusta con | ya que se identifica mejor los diferentes tipos de productos.
-- En el resultado "correcto" se comienza por el signo, cosa que no me gusta porque es menos legible
-- He utilizado en este caso with ties en vez de un rank ya que aunque indicamos un top, si hay otras filas con el mismo conteo las incluye.
