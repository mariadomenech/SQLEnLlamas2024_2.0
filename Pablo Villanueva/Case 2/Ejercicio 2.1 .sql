-- Tabla temporal con los datos limpios
SELECT 
    runner_id,
    order_id,
    pickup_time,
    COALESCE(CAST(SUBSTRING(distance, 1, PATINDEX('%[^0-9.]%', distance + 'a') - 1) AS FLOAT), 0) as cleaned_distance,
    COALESCE(CAST(SUBSTRING(duration, 1, PATINDEX('%[^0-9.]%', duration + 'a') - 1) AS FLOAT)/60, 0) as cleaned_duration 
INTO #CleanedRunnerOrders
FROM case02.runner_orders;

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
