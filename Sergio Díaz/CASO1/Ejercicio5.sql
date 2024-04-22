/* Alumno: Sergio Díaz */
/* CASO 5: Total de puntos de fidelización de cada cliente */


SELECT CUSTOMERS.customer_id AS 'DES_CLIENTE'
	,COALESCE(SUM(CASE 
				WHEN SALES.product_id = 1
					THEN MENU.price * 20
				ELSE MENU.price * 10
				END), 0) AS TOTAL_PUNTOS --case para obtener los puntos en funcion del plato (el sushi id=1 es el doble)
FROM case01.customers CUSTOMERS
LEFT JOIN case01.sales SALES ON CUSTOMERS.customer_id = SALES.customer_id --Left join para obtener todos los clientes (aunque no aparezcan en la tabla de sales)
LEFT JOIN case01.menu MENU 
	ON SALES.product_id = MENU.product_id 
GROUP BY CUSTOMERS.customer_id;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

PERFECTO!

*/
