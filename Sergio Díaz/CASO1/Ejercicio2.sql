/* Alumno: Sergio Díaz */
/* CASO 1 - Ejercicio 2: Total de días de visita al restaurante de cada cliente */

SELECT 
   A.customer_id as 'DES_CLIENTE',
   COALESCE( count(distinct B.order_date), 0) AS 'TOTAL_DIAS' --Metrica para contar dias distintos
FROM 
   case01.customers A 
      LEFT JOIN --Left join para mostrar todos los clientes de la dimension cliente
         case01.sales B
      ON A.customer_id = B.customer_id
GROUP BY 
   A.customer_id
ORDER BY 
   TOTAL_DIAS DESC; --Ordenamos por numero de dias desc


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Perfecto!

*/
