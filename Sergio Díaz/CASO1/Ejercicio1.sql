/* Alumno: Sergio Díaz */
/* CASO 1 - Ejercicio 1: Total de cada cliente en el restaurante */

SELECT 
   A.customer_id as 'DES_CLIENTE',
   COALESCE(B.TOTAL_AUX, 0) AS 'TOTAL_GASTADO'
FROM 
   case01.customers A 
      LEFT JOIN --Left join para mostrar todos los clientes de la dimension cliente
	  ( 
         SELECT   --Subquery para calcular el gasto por cliente de la tabla sales
            a.customer_id,
            SUM(b.price) AS 'TOTAL_AUX' --Agregamos el precio de cada producto
         FROM 
            case01.sales a JOIN case01.menu b --Unimos las tablas de ventas y menu
         ON 
            a.product_id = b.product_id --El campo en comun es el product_id
         GROUP BY 
            a.customer_id
	  ) B
ON A.customer_id = B.customer_id;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto Sergio!

*/
