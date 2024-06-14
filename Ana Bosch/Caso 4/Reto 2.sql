-- RETO 2: ¿Cuál es la combinación de productos distintos más repetida en una sola transacción? La combinación debe ser de al menos 3 productos distintos.

SELECT TOP 1 WITH TIES COUNT(product_set) AS repeticiones
	,product_set
FROM (
	-- Subconsulta para:
	-- 1. Enlazar los product_ids con sus nombres mediante el join
	-- 2. Contar el número de articulos por pedido y eliminar las filas de las que sean menor a 3
	-- 3. Agregamos en una fila los articulos de cada pedido y los separamos por saltos de líneas mediante String_AGG y CHAR(13)
	SELECT txn_id
		,CONCAT('La combinación más repetida es:', CHAR(13),STRING_AGG(CONCAT('- ', product_name), CHAR(13)) WITHIN GROUP (ORDER BY product_name ASC)) AS product_set 
	FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales AS sales
	JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details AS product
		ON sales.prod_id = product.product_id
	GROUP BY txn_id
	HAVING COUNT(*) >= 3
) A
-- En la consulta final:
-- 1. Agregamos por el conjunto de articulos para ver que set es el más repetido
-- 2. Nos quedamos con los de mayor número de repetición. Añadimos WITH TIES por si hubiera algún set con el mismo número de repeticiones salgan todos los sets
GROUP BY product_set
ORDER BY 1 DESC


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Antes de hacer esta solución había realizado la siguiente
 Me dí cuenta que algunas filas agrupaban elementos duplicados por lo que los elimine mediante esta CTE y el DISTINCT */

-- Recupero descripciones cruzando las tablas y elimino duplicados con distinct
WITH CTE_DELETE_DUPLICATED
AS (
	SELECT DISTINCT txn_id
		,product_name 
	FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales AS sales
	JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details AS product
		ON sales.prod_id = product.product_id	
)

/* No obstante, al recuperar la combinación con mayor repetición teniendo en cuenta los empates, el resultado devolvía 
2 filas con empate, un resultado diferente al que debería salir. */
	
SELECT TOP 1 WITH TIES COUNT(product_set) AS repeticiones
	,product_set
FROM (
	-- Cuento el número de articulos por pedido, elimino las filas de las que sean menor a 3 y agrego en una fila los articulos de cada pedido y los separamos por saltos de líneas mediante String_AGG y CHAR(13)
	SELECT txn_id
		,CONCAT('La combinación más repetida es:', CHAR(13),STRING_AGG(CONCAT('- ', product_name), CHAR(13)) WITHIN GROUP (ORDER BY product_name ASC)) AS product_set 
	FROM CTE_DELETE_DUPLICATED
	GROUP BY txn_id
	HAVING COUNT(*) >= 3
) A
-- Agregamos por el conjunto de articulos para ver que set es el más repetido y nos quedamos con los de mayor número de repetición. Añadimos WITH TIES por si hubiera algún set con el mismo número de repeticiones salgan todos los sets
GROUP BY product_set
ORDER BY 1 DESC

/* Imagino que la solución correcta es la que devuelve un único registro, no obstante, por si no fuera así aquí tenéis la solución que lo tiene en cuenta */


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Perfecto, en principio la solución correcta es la primera, pero es lo que tú comentas, que dependería del caso concreto y de si se tomara en cuenta o no esa situación de eliminar duplicados.
Tienes en cuenta las situaciones de empate en la primera posición así que todo genial, enhorabuena!

*/
