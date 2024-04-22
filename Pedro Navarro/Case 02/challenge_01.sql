-- RETO 1. ¿CUÁL ES LA DISTANCIA ACUMULADA DE REPARTO DE CADA RUNNER?
-- ¿Y LA VELOCIDAD PROMEDIO (EN KM/H)?
-- PATINDEX: Devuelve la posición inicial de la primera repetición de un patrón. Personalmente, esta opción la veo más flexible en comparación con REPLACE.
-- Por ejemplo, en "distance" podría admitir las opciones kilometers y kms. En cuanto a "duration", evitas tener que hacer REPLACE anidados.
;WITH

	CUSTOMER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,runner_id
			,CAST(NULLIF(pickup_time, 'null') AS DATETIME) AS pickup_time
			,CAST(
				CASE
					WHEN PATINDEX('%k%m%', distance) > 0 
						THEN TRIM(SUBSTRING(distance, 1, PATINDEX('%k%m%', distance)-1))
					ELSE REPLACE(LOWER(TRIM(distance)), 'null', 0)
				END AS FLOAT) AS distance_in_km
			,CAST(
				CASE
					WHEN PATINDEX('%min%', duration) > 0 
						THEN TRIM(SUBSTRING(duration, 1, PATINDEX('%min%', duration)-1))
					ELSE REPLACE(LOWER(TRIM(duration)), 'null', 0)
				END AS FLOAT) AS duration_in_min
			,CASE
				WHEN cancellation IN ('', 'null') THEN NULL
				ELSE cancellation
			END AS cancellation
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	)

	,TOTAL_DISTANCE_AND_AVERAGE_SPEED_PER_TOTAL_RUNNERS AS (
		SELECT
			r.runner_id
			,ROUND(ISNULL(SUM(co.distance_in_km), 0), 1) AS total_distance_in_km
			,ROUND(ISNULL(AVG(co.distance_in_km/NULLIF(co.duration_in_min, 0))*60, 0), 1) AS average_speed_in_km_per_hour
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners AS r
		LEFT JOIN CUSTOMER_ORDERS_CLEANED AS co
			ON r.runner_id = co.runner_id
		GROUP BY r.runner_id
	)

SELECT *
FROM TOTAL_DISTANCE_AND_AVERAGE_SPEED_PER_TOTAL_RUNNERS;
