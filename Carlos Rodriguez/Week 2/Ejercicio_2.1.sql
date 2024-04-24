-- Primero, creamos una tabla temporal con los datos limpios
SELECT 
    runner_id,
    order_id,
    pickup_time,
    COALESCE(CAST(SUBSTRING(distance, 1, PATINDEX('%[^0-9.]%', distance + 'a') - 1) AS FLOAT), 0) as cleaned_distance,
    COALESCE(CAST(SUBSTRING(duration, 1, PATINDEX('%[^0-9.]%', duration + 'a') - 1) AS FLOAT)/60, 0) as cleaned_duration 
INTO #CleanedRunnerOrders
FROM case02.runner_orders;

-- Luego, calculamos la velocidad promedio de cada corredor y la distancia acumulada.
SELECT 
    runner_id,
    COALESCE(SUM(cleaned_distance), 0) as Distancia_Total,
    SUM(cleaned_duration) as total_hours,
    COALESCE(AVG(CASE WHEN cleaned_duration > 0 THEN cleaned_distance/cleaned_duration ELSE NULL END), 0) as Velocidad_Promedio_km_h
INTO #RunnerOrdersWithSpeed
FROM #CleanedRunnerOrders
GROUP BY runner_id;


SELECT 
    r.runner_id,
    CAST(ROUND(ISNULL(ro.Distancia_Total, 0), 2) AS DECIMAL(18, 2)) as Distancia_Total,
    CAST(ROUND(ISNULL(ro.Velocidad_Promedio_km_h, 0), 2) AS DECIMAL(18, 2)) as Velocidad_Promedio_km_h
FROM case02.runners r
LEFT JOIN #RunnerOrdersWithSpeed ro ON r.runner_id = ro.runner_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

A modo de detalle, para el tema de la limpieza de los campos Distancia y Duración se podría hacer de una forma mas general que eliminaría todo los caracteres deseados independientemente de su posición
en la cadena:

	case
		when distance IN ('',' ','null','NULL') then NULL
		else CAST(REPLACE(TRANSLATE(distance, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ', 52)),' ','') as float)
	end as distance,
	case
		when duration IN ('',' ','null','NULL') then NULL
		else CAST(REPLACE(TRANSLATE(duration, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', REPLICATE(' ', 52)),' ','') as float)
	end as duration,

 En la función TRANSLATE la cadena de caractares que queremos quitar ('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz') y la cadena de la traduccion (REPLICATE(' ', 52)),' ','')) deben tener la misma
longitud, de ahí el uso de REPLICATE. En la cadena de caractares que queremos quitar podemos tambien incluir cualquier símbolo (€ por ejemplo) aunque habria que tener cuidado de no incluir símbolos como
 "." "," o "-" ente otros ya que se podrian usar en campos de importes por ejemplo.

*/
