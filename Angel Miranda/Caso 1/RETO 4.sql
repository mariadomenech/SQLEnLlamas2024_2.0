WITH TABLA_PEDIDOS AS
(SELECT 
	PRODUCT_ID,
	COUNT(PRODUCT_ID) AS NUM_PEDIDOS,
	RANK() OVER (ORDER BY COUNT(PRODUCT_ID) DESC) AS ORDEN
FROM CASE01.SALES
GROUP BY PRODUCT_ID)

SELECT
	PRODUCT_NAME,
	NUM_PEDIDOS
FROM TABLA_PEDIDOS A
JOIN CASE01.MENU B ON A.PRODUCT_ID = B.PRODUCT_ID
WHERE ORDEN = 1;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

PERFECTO! Con el RANK tienes en cuenta posibles empates.

*/
