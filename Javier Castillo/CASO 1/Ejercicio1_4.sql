SELECT TOP 1
M.product_name, COUNT(1) AS NUM_PEDIDOS
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] AS M
	ON S.product_id=M.product_id
GROUP BY M.product_name
ORDER BY NUM_PEDIDOS DESC;