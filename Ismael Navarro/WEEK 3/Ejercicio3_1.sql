--Primero, creo una tabla para tratar si el customer ha cambiado de nodo o no
WITH CHANGE_CUSTOMER_NODE AS (
SELECT 
	CUSTOMER_ID,
	NODE_ID,
	START_DATE,
	END_DATE,
	DATEDIFF(day, START_DATE, END_DATE) AS DIAS_DIFF,
	IIF(LAG(NODE_ID, 1,0) OVER (PARTITION BY CUSTOMER_ID ORDER BY START_DATE) = NODE_ID, 0, 1) AS NODE_CHANGE
FROM CASE03.CUSTOMER_NODES),
--Aquí se hacen transformaciones para ajustar la consulta final respecto a los días que un cliente está en un nodo
DIMENSION_TABLE AS (
SELECT 
	CUSTOMER_ID,
	NODE_ID,
	START_DATE,
	END_DATE,
	CASE WHEN NODE_CHANGE=0 THEN DIAS_DIFF + 1 ELSE DIAS_DIFF END AS DIAS_DIFF, -- se le suma 1 cuando no hay cambio de nodo para ajustar el conteo de días correctamente, ya que DATEDIFF deja un día suelto.
	SUM(NODE_CHANGE) OVER (ORDER BY  CUSTOMER_ID,START_DATE) DIMENSION_NODE_CHANGE
FROM CHANGE_CUSTOMER_NODE)

SELECT 
	ROUND(AVG(CAST(DAYS AS FLOAT)),2) AS AVG_DAYS_PER_NODE
FROM(
	SELECT 
		DIMENSION_NODE_CHANGE,
		IIF(SUM(DIAS_DIFF)>5000, NULL, SUM(DIAS_DIFF)) AS DAYS -- el valor 5000 es un valor arbitrario muy elevado para trabajar posibles casos de resultados dispares
	FROM DIMENSION_TABLE
	GROUP BY DIMENSION_NODE_CHANGE) TEMP;
