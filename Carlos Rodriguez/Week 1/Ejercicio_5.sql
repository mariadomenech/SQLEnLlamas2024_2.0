SELECT 
   C.CUSTOMER_ID AS CLIENTE,
   COALESCE(SUM(PUNTUACION), 0) AS PUNTUACION_FINAL
FROM CASE01.CUSTOMERS C
LEFT JOIN (
    SELECT 
       S.CUSTOMER_ID,
       CASE 
           WHEN M.PRODUCT_ID = 1 THEN M.PRICE * 20
           ELSE M.PRICE * 10
       END AS PUNTUACION
    FROM CASE01.SALES S
    INNER JOIN CASE01.MENU M ON M.PRODUCT_ID = S.PRODUCT_ID
) AS AUX ON AUX.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID
ORDER BY C.CUSTOMER_ID;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
