/*
Fidelización
Cada € gastado  equivale a 10 puntos
El sushi tiene un multiplicador x2 puntos
*/

SELECT 
C.customer_id AS CLIENTE
, ISNULL( SUM( M.price*CASE WHEN M.product_name = 'sushi' THEN 2 ELSE 1 END ) * 10,0) AS GASTO_TOTAL
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] AS C
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
	ON C.customer_id = S.customer_id
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] AS M
	ON S.product_id=M.product_id

GROUP BY C.customer_id
ORDER BY CLIENTE;