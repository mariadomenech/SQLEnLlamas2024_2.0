/*
Distancia acumulada de cada Runner
Velocidad Promedio km/h

Comentarios: Hace falta calidad en el DWH para unificar los valores null y unificar los valores de distancia y duracion
*/
SELECT 
	RUNNER
,	CONCAT( CASE WHEN SUM(CAST( DISTANCE AS FLOAT)) <>0 THEN SUM(CAST( DISTANCE AS FLOAT)) ELSE 0 END , ' KM' ) AS DISTANCIA_ACUMULADA
,	CONCAT(ROUND(AVG(CASE WHEN CAST( DURATION AS FLOAT)<>0 THEN CAST( DISTANCE AS FLOAT) / CAST( DURATION AS FLOAT)*60 ELSE 0 END),2) , ' KM/H') AS VELOCIDAD_PROMEDIO
FROM (
	SELECT 
	   R.runner_id AS RUNNER
	,  SUBSTRING( O.distance, PATINDEX('%[0-9]%', O.distance), CASE WHEN PATINDEX('%[ A-Za-z]%', O.distance)=0 THEN LEN(TRIM(O.distance)) ELSE  PATINDEX('%[ A-Za-z]%', O.distance)-1 END ) AS DISTANCE
	,  SUBSTRING( O.duration, PATINDEX('%[0-9]%', O.duration), CASE WHEN PATINDEX('%[ A-Za-z]%', O.duration)=0 THEN LEN(TRIM(O.duration)) ELSE  PATINDEX('%[ A-Za-z]%', O.duration)-1 END ) AS DURATION
	FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].runners AS R
	LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case02].[runner_orders] AS O
		ON R.runner_id = O.runner_id
)A
GROUP BY RUNNER
ORDER BY RUNNER;