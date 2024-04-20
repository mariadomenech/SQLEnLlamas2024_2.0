/* Josep quiere repartir tarjetas de fidelización a sus clientes. Si cada euro gastado equivale a 10 puntos
y el shushi tiene un multiplicador de x2 puntos. ¿Cuántos puntos tendría cada cliente?*/

SELECT 
  cust.customer_id
  , COALESCE(SUM(CASE WHEN menu.product_name = 'sushi' then menu.price * 20 else menu.price * 10 end), 0) as puntos_fidelizacion
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers cust
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
  ON cust.customer_id = sales.customer_id
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
	ON menu.product_id = sales.product_id
GROUP BY cust.customer_id
ORDER BY 1;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Todo correcto, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK. Un pequeño detalle, cuando utilizamos CASE WHEN cada WHEN (o el ELSE en este caso) yo lo suelo alinear debajo del anterior WHEN. Te muestro como lo haría:
			SELECT 
			  cust.customer_id
			  , COALESCE(SUM(CASE WHEN menu.product_name = 'sushi' then menu.price * 20 
					      ELSE menu.price * 10 END)
			            , 0) AS puntos_fidelizacion
			FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers cust
			LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
			  ON cust.customer_id = sales.customer_id
			LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
				ON menu.product_id = sales.product_id
			GROUP BY cust.customer_id
			ORDER BY 1;



*/
