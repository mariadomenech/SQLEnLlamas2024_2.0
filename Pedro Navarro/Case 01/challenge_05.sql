-- RETO 5.¿JOSEP QUIERE REPARTIR TARJETAS DE FIDELIZACIÓN A SUS CLIENTES. SI CADA EURO GASTADO EQUIVALE A 10 PUNTOS
-- Y EL SUSHI TIENE UN MULTIPLICADOR DE X2 PUNTOS, ¿CUÁNTOS PUNTOS TENDRÍA CADA CLIENTE?
SELECT
	c.customer_id
	,ISNULL(SUM(
		CASE
			WHEN m.product_name LIKE 'sushi' THEN m.price*2*10
			ELSE m.price*1*10
		END), 0) AS points
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers AS c
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales AS s
	ON c.customer_id = s.customer_id
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu AS m
	ON s.product_id = m.product_id
GROUP BY c.customer_id;


/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*
Todo perfecto, enhorabuena! A por el CASO 2!
*/
