/*¿CUÁNTOS DÍAS HA VISITADO EL RESTAURANTE CADA CLIENTE?*/

USE [SQL_EN_LLAMAS_ALUMNOS]

SELECT 
	C.CUSTOMER_ID AS ID_CLIENTE,
	COUNT(DISTINCT S.ORDER_DATE) AS VISITAS
FROM [case01].[customers] C
LEFT JOIN [case01].[sales] S
	ON C.CUSTOMER_ID = S.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY VISITAS DESC;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

Perfecto Julia!!!

*/
