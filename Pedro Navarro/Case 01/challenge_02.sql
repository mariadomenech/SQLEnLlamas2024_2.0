-- RETO 2. ¿CUÁNTOS DÍAS HA VISITADO EL RESTAURANTE CADA CLIENTE?
-- SOLUCIÓN 1: MÁS SENCILLA (UNA SOLA QUERY)
-- En este caso, no haría falta un ISNULL como en la solución 2 porque, al hacer directamente la unión,
-- el valor de "total_days" para customer_id = "D" se rellena con un NULL (que no es contado por el COUNT de COLUMNAS)
SELECT
	c.customer_id
	,COUNT(DISTINCT s.order_date) AS total_days
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
	ON c.customer_id = s.customer_id
GROUP BY c.customer_id;


-- SOLUCIÓN 2: MÁS COMPLEJA (VARIAS CTES)
;WITH
	TOTAL_DAYS_VISITED_PER_CUSTOMER AS (
		SELECT
			customer_id
			,COUNT(DISTINCT order_date) AS total_days
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
		GROUP BY customer_id
	),
	
	TOTAL_DAYS_VISITED_PER_TOTAL_CUSTOMER AS (
		SELECT
			c.customer_id
			,ISNULL(d.total_days, 0) AS total_days
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
		LEFT JOIN TOTAL_DAYS_VISITED_PER_CUSTOMER AS d
			ON c.customer_id = d.customer_id
	)

SELECT *
FROM TOTAL_DAYS_VISITED_PER_TOTAL_CUSTOMER;
