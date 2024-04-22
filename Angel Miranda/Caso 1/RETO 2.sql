SELECT	A.CUSTOMER_ID,
	COUNT(DISTINCT B.ORDER_DATE) DIAS_VISITADOS
FROM	CASE01.CUSTOMERS A
	LEFT OUTER JOIN CASE01.SALES B
		ON A.CUSTOMER_ID=B.CUSTOMER_ID
	LEFT OUTER JOIN CASE01.MENU C
		ON B.PRODUCT_ID=C.PRODUCT_ID
GROUP BY A.CUSTOMER_ID;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

Guay! Aunque el último LEFT JOIN es prescindible. 
En una base de datos con una volumetría tan pobre como la que estamos trabajando no tiene impacto en la CPU, 
pero pensando en optimizar el código lo quitaría.

*/
