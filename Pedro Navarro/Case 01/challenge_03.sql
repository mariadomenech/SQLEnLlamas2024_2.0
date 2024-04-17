-- RETO 3. ¿CUÁL ES EL PRIMER PRODUCTO QUE HA PEDIDO CADA CLIENTE?
-- SOLUCIÓN 1: USANDO FUNCIÓN DE VENTANA "DENSE_RANK"
;WITH

	CUSTOMER_PRODUCTS_RANKING AS (
		SELECT DISTINCT
			c.customer_id
			,DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS order_date_rank
			,m.product_name
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
			ON c.customer_id = s.customer_id
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
			ON s.product_id = m.product_id
	)

	,FIRST_PRODUCTS_PER_TOTAL_CUSTOMERS AS (
		SELECT
			customer_id
			,ISNULL(STRING_AGG(product_name, ', '), 'sin producto(s)') AS product_name
		FROM CUSTOMER_PRODUCTS_RANKING
		WHERE order_date_rank = 1
		GROUP BY customer_id
	)

SELECT *
FROM FIRST_PRODUCTS_PER_TOTAL_CUSTOMERS;


-- SOLUCIÓN 2: USANDO FUNCIÓN DE AGREGACIÓN "MIN"
;WITH

	FIRST_ORDER_DATE_PER_CUSTOMER AS (
		SELECT
			customer_id
			,MIN(order_date) AS first_order_date
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
		GROUP BY
			customer_id
	)

	,FIRST_PRODUCTS_PER_CUSTOMERS AS (
		SELECT DISTINCT
			s.customer_id
			,fod.first_order_date
			,m.product_name
		FROM FIRST_ORDER_DATE_PER_CUSTOMER AS fod
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
			ON fod.customer_id = s.customer_id AND fod.first_order_date = s.order_date
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
			ON s.product_id = m.product_id
	)

	,FIRST_PRODUCTS_PER_TOTAL_CUSTOMERS AS (
		SELECT
			c.customer_id
			,ISNULL(STRING_AGG(fp.product_name, ', '), 'sin producto(s)') AS product_name
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
		LEFT JOIN FIRST_PRODUCTS_PER_CUSTOMERS AS fp
			ON c.customer_id = fp.customer_id
		GROUP BY c.customer_id
	)

SELECT *
FROM FIRST_PRODUCTS_PER_TOTAL_CUSTOMERS;
