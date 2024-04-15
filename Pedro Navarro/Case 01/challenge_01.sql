-- RETO 1. ¿CUÁNTO HA GASTADO EN TOTAL CADA CLIENTE EN EL RESTAURANTE?
;WITH
	TOTAL_SPENT_PER_CUSTOMER AS (
		SELECT
			customer_id,
			SUM(price) AS total_spent
		FROM
			SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
		LEFT JOIN
			SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
		ON
			s.product_id = m.product_id
		GROUP BY
			customer_id
	),
	
	TOTAL_SPENT_PER_TOTAL_CUSTOMER AS (
		SELECT
			c.customer_id,
			ISNULL(s.total_spent, 0) AS total_spent
		FROM
			SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
		LEFT JOIN
			TOTAL_SPENT_PER_CUSTOMER AS s
		ON
			c.customer_id = s.customer_id
	)

SELECT
	*
FROM
	TOTAL_SPENT_PER_TOTAL_CUSTOMER
;
