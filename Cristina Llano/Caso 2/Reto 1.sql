-- ¿Cuál es la distancia acumulada de reparto de cada runner?
-- ¿Y la velocidad promedio (en KM/h)?

--Se realiza limpieza de datos además de calculos base de sumatorios y transformación a tipos de datos correctos
WITH tmp_runner_orders AS(
	SELECT runner_id
		, SUM( CAST (CASE WHEN (distance is null OR distance = 'null') THEN '0'
					 ELSE REPLACE(distance, 'km','') END
				AS DECIMAL(3,1))) AS distancia_total
		, SUM( CAST (CASE WHEN (duration is null OR duration = 'null') THEN '0'
					 ELSE SUBSTRING(duration,1,2) END 
				AS DECIMAL(4,2)))/60 AS tiempo_total_hora
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	GROUP BY runner_id
)

-- Para que quede más legible se incluye el tipo de información que se aporta, km o km/h
SELECT runner
	, CONCAT (distancia_acumulada, ' km') AS distancia_acumulada
	, CONCAT (velocidad_promedio, ' km/h') AS velocidad_promedio
FROM
(
	SELECT run.runner_id AS runner
		, COALESCE(MAX(reparto.distancia_total),0) AS distancia_acumulada
		, CAST(COALESCE(AVG(reparto.distancia_total / reparto.tiempo_total_hora),0) AS DECIMAL (4,2)) AS velocidad_promedio
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners run
	LEFT JOIN tmp_runner_orders reparto
		ON run.runner_id = reparto.runner_id
	GROUP BY run.runner_id
) FINAL ;