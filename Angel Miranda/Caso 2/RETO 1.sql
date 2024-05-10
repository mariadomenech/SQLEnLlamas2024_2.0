WITH RUNNER_ORDERS_V2 AS (SELECT
	ORDER_ID,
	B.RUNNER_ID,
	PICKUP_TIME,
	CAST(LEFT(DISTANCE,PATINDEX('%[^0-9-.]%', DISTANCE + ' ') - 1) AS FLOAT) AS DISTANCE,
	CAST(LEFT(DURATION,PATINDEX('%[^0-9-.]%', DURATION + ' ') - 1) AS FLOAT)/60 AS DURATION_HOURS,
	CASE WHEN CANCELLATION LIKE '%CANCEL%' THEN 1 ELSE 0 END AS CANCELADO
FROM CASE02.RUNNER_ORDERS A
RIGHT OUTER JOIN CASE02.RUNNERS B ON A.RUNNER_ID=B.RUNNER_ID),

TABLA_DISTANCIA_VELOCIDAD AS (SELECT
	RUNNER_ID,
	COALESCE(DISTANCE,0) AS DISTANCE,
	CASE WHEN DURATION_HOURS > 0 THEN DISTANCE/DURATION_HOURS ELSE 0 END AS VELOCIDAD_KMH,
	CANCELADO
FROM RUNNER_ORDERS_V2)

SELECT
	RUNNER_ID,
	CAST(SUM(DISTANCE) AS DECIMAL(20,2)) AS DISTANCIA_TOTAL,
	CAST(AVG(VELOCIDAD_KMH) AS DECIMAL(20,2)) AS MEDIA_VELOCIDAD
FROM TABLA_DISTANCIA_VELOCIDAD A
WHERE CANCELADO = 0 
GROUP BY RUNNER_ID;

/*
Corrección Pablo: ¡Todo perfecto!

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Genial la limpieza de los datos, el control del runner extra y la ejecución de los cálculos.
Legibilidad: OK. Me encanta el uso de CTEs, resulta más fácil de entender el código en mi opinión. Entiendo que empleaste una 
segunda CTE para mantener el código limpio y encapsulado en lugar de hacerlo todo a la vez en una única CTE, ¡resulta muy visual!

¡Enhorabuena!
*/
