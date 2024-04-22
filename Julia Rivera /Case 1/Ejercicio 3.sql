/*RETO 3: ¿CUÁL ES EL PRIMER PRODUCTO QUE HA PEDIDO CADA CLIENTE?*/

USE [SQL_EN_LLAMAS_ALUMNOS]

SELECT 
	PRIMER_PRODUCTO,
	ID_CLIENTE
FROM (
	SELECT	
		S.CUSTOMER_ID AS ID_CLIENTE,
		M.PRODUCT_NAME AS PRIMER_PRODUCTO,
		ROW_NUMBER() OVER (PARTITION BY S.CUSTOMER_ID ORDER BY S.ORDER_DATE) AS ROW_NUM
	FROM [case01].[sales] S
	INNER JOIN [case01].[menu] M
		ON S.PRODUCT_ID = M.PRODUCT_ID
) AS SUBCONSULTA
WHERE ROW_NUM = 1;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Incorrecto
CÓDIGO: Estás utilizando row_number pero habría que usar rank, intenta usar más left o right joins. 
	Cuando hagas una subconsulta intenta ponerlas en una CTE para que se quede más limpito el código
LEGIBILIDAD: Correcta


AQUÍ TIENES UN EJEMPLO DE CÓMO SE PODRÍA HACER:
______________________________________________
WITH CTE AS(
    SELECT
        DISTINCT me.customer_id cliente,
        m.product_name, 
        s.order_date,
        RANK() OVER(PARTITION BY me.customer_id ORDER BY s.order_date) AS SEQ
    FROM SQL_EN_LLAMAS.CASE01.CUSTOMERS me
        LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES s ON me.customer_id = s.customer_id
        LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU m ON s.product_id = m.product_id
) 
SELECT 
     cliente,
     COALESCE(STRING_AGG(product_name, ', '),' ') AS "PRIMER PRODUCTO QUE HA PEDIDO"
FROM CTE
WHERE SEQ = 1
GROUP BY cliente
ORDER BY cliente;

*/

