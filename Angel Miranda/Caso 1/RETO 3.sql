WITH TABLA_ORDENES AS
(SELECT DISTINCT
	C.CUSTOMER_ID,
	COALESCE(B.PRODUCT_NAME,'No ha pedido') AS PRODUCT_NAME,
	ORDER_DATE,
	RANK() OVER(PARTITION BY C.CUSTOMER_ID ORDER BY ORDER_DATE) AS ORDEN
FROM CASE01.SALES A
	LEFT OUTER JOIN CASE01.MENU B ON A.PRODUCT_ID = B.PRODUCT_ID
	RIGHT OUTER JOIN CASE01.CUSTOMERS C ON A.CUSTOMER_ID = C.CUSTOMER_ID)

SELECT
	CUSTOMER_ID,
	STRING_AGG(PRODUCT_NAME, ', ') PRODUCTO
FROM TABLA_ORDENES
WHERE ORDEN = 1
GROUP BY CUSTOMER_ID


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

PERFECTO! Me gusta que hayas recuqrrido a un RANK(), queda más simplificado el código que por subconsulta.

*/
