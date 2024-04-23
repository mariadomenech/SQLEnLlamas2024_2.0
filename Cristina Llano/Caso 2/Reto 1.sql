-- ¿Cuál es la distancia acumulada de reparto de cada runner?
-- ¿Y la velocidad promedio (en KM/h)?

--Se realiza limpieza de datos además de calculos base de sumatorios y transformación a tipos de datos correctos
WITH tmp_runner_orders AS(
	SELECT runner_id
		, CAST (CASE WHEN (distance is null OR distance = 'null') THEN '0'
					 ELSE REPLACE(distance, 'km','') END
				AS DECIMAL(4,2)) AS distancia_total
		, CAST (CASE WHEN (duration is null OR duration = 'null') THEN '0'
					 ELSE SUBSTRING(duration,1,2) END 
				AS DECIMAL(4,2))/60 AS tiempo_total_hora
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders

)

-- Para que quede más legible se incluye el tipo de información que se aporta, km o km/h
SELECT runner
	, CONCAT (distancia_acumulada, ' KM') AS distancia_acumulada
	, CONCAT (velocidad_promedio, ' KM/H') AS velocidad_promedio
FROM
(
	SELECT run.runner_id AS runner
		, COALESCE(SUM(reparto.distancia_total),0) AS distancia_acumulada
		, CAST( COALESCE(AVG(reparto.distancia_total / reparto.tiempo_total_hora),0) AS DECIMAL (4,2)) AS velocidad_promedio
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runners run
	LEFT JOIN tmp_runner_orders reparto
		ON run.runner_id = reparto.runner_id
		AND reparto.tiempo_total_hora > 0 -- Excluimos valor cero para no dividir por él
	GROUP BY run.runner_id
) FINAL ;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Todo correcto Cristina, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Me ha gustado el detalle de controlar los casos en los que la duración pueda venir a 0 (aunque sería un problema con la calidad de los datos)

*/
