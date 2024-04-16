/****** 
Cuantos días ha visitado el restaurante cada cliente 
Salida ordenada por nº dias visitados
******/
  SELECT C.customer_id AS CLIENTE
		, COUNT(DISTINCT S.order_date) AS DIAS_VISITADOS
  FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] AS C
  LEFT OUTER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
	ON C.customer_id=S.customer_id
  GROUP BY C.customer_id
  ORDER BY DIAS_VISITADOS DESC,CLIENTE;