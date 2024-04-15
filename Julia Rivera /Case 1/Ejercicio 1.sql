/*RETO 1: ¿CUÁNTO HA GASTADO EN TOTAL CADA CLIENTE EN EL RESTAURANTE?*/

USE [SQL_EN_LLAMAS_ALUMNOS]
GO

SELECT 
	C.CUSTOMER_ID AS ID_CLIENTE,
	CASE 
		WHEN SUM(PRICE) IS NULL 
			THEN 0
			ELSE SUM(PRICE)
	END AS TOTAL_GASTADO
FROM [case01].[menu] M
LEFT JOIN [case01].[sales] S
ON M.PRODUCT_ID = S.PRODUCT_ID
RIGHT JOIN [case01].[customers] C
ON S.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID

GO

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

El resultado es completamente correcto!

Aun así te voy a dar dos tips:
	- En vez de usar el case when, puedes usar directamente un COALESCE (SUM (price),0) AS TOTAL_GASTADO --> Con esto el código se ve más conciso.
	- Yo primero me pararía a pensar qué tabla es la dimension principal y eligiría una dirección de join. 
		+ Al coger la columna de CUSTOMER_ID de la tabla CUSTOMERS, esta es tu tabla principal. A partir de ésta, vamos encajando las otras tablas. Entonces, de la
		tabla CUSTOMERS podemos ir a la de SALES con un LEFT JOIN y seguidamente a la de MENU con un LEFT JOIN. 
		+ De esta forma ya tenemos todas las columnas ligadas en una sola dirección (LEFT) desde la tabla principal (CUSTOMERS).


*/
