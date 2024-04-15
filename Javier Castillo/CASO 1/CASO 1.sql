/****** Gasto total de cada cliente  ******/
SELECT 
  C.customer_id AS CLIENTE
, COALESCE(SUM(M.price),0) AS GASTO_TOTAL
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] AS C
LEFT OUTER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
	ON C.customer_id = S.customer_id
LEFT OUTER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] AS M
	ON S.product_id = M.product_id
GROUP BY C.customer_id
ORDER BY C.customer_id;
