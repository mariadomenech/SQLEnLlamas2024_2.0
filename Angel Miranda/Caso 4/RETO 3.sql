SELECT
	PRODUCT_ID,
	PRICE,
	CONCAT(B.LEVEL_TEXT,' ',C.LEVEL_TEXT,' - ',D.LEVEL_TEXT) AS PRODUCT_NAME,
	D.ID AS CATEGORY_ID,
	C.ID AS SEGMENT_ID,
	B.ID AS STYLE_ID,
	D.LEVEL_TEXT AS CATEGORY_NAME,
	C.LEVEL_TEXT AS SEGMENT_NAME,
	B.LEVEL_TEXT AS STYLE_NAME
FROM CASE04.PRODUCT_PRICES A
JOIN CASE04.PRODUCT_HIERARCHY B ON A.ID = B.ID
JOIN CASE04.PRODUCT_HIERARCHY C ON B.PARENT_ID = C.ID
JOIN CASE04.PRODUCT_HIERARCHY D ON C.PARENT_ID = D.ID;

/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Sencillo, no?

Código: OK
Legibilidad: OK
Resultado: OK
*/
