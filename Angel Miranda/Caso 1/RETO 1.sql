SELECT	C.CUSTOMER_ID,
	SUM(COALESCE(B.PRICE,0)) AS TOTAL_GASTADO
FROM	CASE01.SALES A
	LEFT OUTER JOIN CASE01.MENU B
		ON A.PRODUCT_ID=B.PRODUCT_ID
	RIGHT OUTER JOIN CASE01.CUSTOMERS C
		ON A.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

PERFECTO!

*/
