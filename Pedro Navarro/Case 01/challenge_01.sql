-- RETO 1. ¿CUÁNTO HA GASTADO EN TOTAL CADA CLIENTE EN EL RESTAURANTE?
-- SOLUCIÓN 1: MÁS SENCILLA (UNA SOLA QUERY)
SELECT
	c.customer_id
	,ISNULL(SUM(m.price), 0) AS total_spent
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
    ON c.customer_id = s.customer_id
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
    ON s.product_id = m.product_id
GROUP BY c.customer_id;


-- SOLUCIÓN 2: MÁS COMPLEJA (VARIAS CTES)
;WITH
	TOTAL_SPENT_PER_CUSTOMER AS (
		SELECT
			customer_id
			,SUM(price) AS total_spent
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
		    ON s.product_id = m.product_id
		GROUP BY customer_id
	),
	
	TOTAL_SPENT_PER_TOTAL_CUSTOMER AS (
		SELECT
			c.customer_id
			,ISNULL(s.total_spent, 0) AS total_spent
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
		LEFT JOIN TOTAL_SPENT_PER_CUSTOMER AS s
		    ON c.customer_id = s.customer_id
	)

SELECT *
FROM TOTAL_SPENT_PER_TOTAL_CUSTOMER;


/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*

Resultado: Correcto.

Código: Correcto. Bien partiendo de la de customers para obtener a todos los clientes independientemente de si han comprado o no
y bien tratado el uso de los nulos con ISNULL.

Legibilidad: Perfecta. Da gusto leer código así.

Muy buen trabajo, además, has querido presentar una solución más compleja lo cual está perfecto, aunque como estos primeros retos
son muy sencillos, no hace falta complicar en exceso lo que ya es fácil de por si jeje.

*/
