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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien visto el cliente que no ha realizado ningún gasto en el restaurante.
Legibilidad: OK. Esto es más subjetivo, pero a mí me gusta como has presentado el ejercicio.

Además, me ha gustado que nombres las columnas y ordenes la salida. 
Como único detalle a comentar, si bien es cierto que la función de agregación SUM no tiene en cuenta los nulos,
personalmente considero más correcto limpiar los nulos antes de la suma, es decir, SUM(COALESCE(M.price),0)) en lugar de COALESCE(SUM(M.price),0).

¡Enhorabuena!
*/
