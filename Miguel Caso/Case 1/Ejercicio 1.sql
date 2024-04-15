SELECT
    c.customer_id AS cliente,
    COALESCE (SUM (price),0) AS total_gasto
FROM SQL_EN_LLAMAS.CASE01.SALES a
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU b ON a.product_id = b.product_id
RIGHT JOIN SQL_EN_LLAMAS.CASE01.CUSTOMERS c ON a.customer_id = c.customer_id
GROUP BY c.customer_id;


/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/

/* 

El resultado es completamente correcto!!

No obstante te voy a dar un tip:
	- Yo primero me pararía a pensar qué tabla es la dimension principal y eligiría una dirección de join. 
		+ Al coger la columna de CUSTOMER_ID de la tabla CUSTOMERS, esta es tu tabla principal. A partir de ésta, vamos encajando las otras tablas. Entonces, de la
		tabla CUSTOMERS podemos ir a la de SALES con un LEFT JOIN y seguidamente a la de MENU con un LEFT JOIN. 
		+ De esta forma ya tenemos todas las columnas ligadas en una sola dirección (LEFT) desde la tabla principal (CUSTOMERS).

*/
