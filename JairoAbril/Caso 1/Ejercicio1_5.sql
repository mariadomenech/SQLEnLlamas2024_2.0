SELECT 
    CUST.CUSTOMER_ID AS CLIENTE,
    COALESCE(SUM(CASE 
                    WHEN MENU.PRODUCT_NAME = 'sushi' THEN MENU.PRICE * 20 
                    ELSE MENU.PRICE * 10 
                 END), 0) AS PUNTOS
FROM case01.customers CUST
LEFT JOIN 
    case01.sales SALES ON CUST.CUSTOMER_ID = SALES.CUSTOMER_ID
LEFT JOIN 
    case01.menu MENU ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY 
    CUST.CUSTOMER_ID;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*******************************************************/
/* 

Resultado y código: PERFECTO!

Legibilidad: Ok!

*/
