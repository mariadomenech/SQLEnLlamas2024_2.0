-- RETO 4. ¿CUÁL ES EL PRODUCTO MÁS PEDIDO DEL MENÚ Y CUANTAS VECES HA SIDO PEDIDO?
-- SOLUCIÓN 1: DOS CTES USANDO TOP-COUNT
;WITH

	MAX_SALES_VALUE AS (
		SELECT TOP 1
			COUNT(product_id) AS max_total_sales
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
		GROUP BY product_id
		ORDER BY COUNT(product_id) DESC

	)

	,MOST_SELLED_PRODUCTS AS (
		SELECT
			m.product_name
			,COUNT(m.product_name) AS total_sales
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
			ON s.product_id = m.product_id
		GROUP BY m.product_name
		HAVING COUNT(m.product_name) = (SELECT max_total_sales FROM MAX_SALES_VALUE)

	)

SELECT *
FROM MOST_SELLED_PRODUCTS;


-- SOLUCIÓN 2: DOS CTES USANDO FUNCIÓN DE VENTANA DENSE_RANK-COUNT
-- Si en SQL Server existiese la cláusula QUALIFY se podría hacer en una sola query
;WITH

	PRODUCT_SALES_DESC_RANKING AS (
		SELECT
			m.product_name
			,COUNT(m.product_name) AS total_sales
			,DENSE_RANK() OVER ( ORDER BY COUNT(m.product_name) DESC) AS max_total_sales
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
			ON s.product_id = m.product_id
		GROUP BY m.product_name

	)

	,MOST_SELLED_PRODUCTS AS (
		SELECT
			product_name
			,total_sales
		FROM PRODUCT_SALES_DESC_RANKING
		WHERE max_total_sales = 1

	)

SELECT *
FROM MOST_SELLED_PRODUCTS;
