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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien aplicado el COUNT DISTINCT.
Legibilidad: OK. Esto es más subjetivo, pero a mí me gusta como has presentado el ejercicio,
aunque es cierto que prefiero alinear las columnas que seleccionas:
*/

SELECT 
    C.customer_id AS CLIENTE
    , COUNT(DISTINCT S.order_date) AS DIAS_VISITADOS
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] AS C
LEFT OUTER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
    ON C.customer_id=S.customer_id
GROUP BY C.customer_id
ORDER BY DIAS_VISITADOS DESC,CLIENTE;

/*
Además, me ha gustado que ordenes la salida. ¡Enhorabuena!
*/
