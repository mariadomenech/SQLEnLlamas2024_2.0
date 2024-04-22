-- Hay que limpiar los datos primero
WITH CleanedRunnerOrders AS (
    SELECT 
        runner_id,
        order_id,
        pickup_time,
        COALESCE(CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + 'a') - 1) AS FLOAT), 0) as cleaned_distance,
        COALESCE(CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + 'a') - 1) AS FLOAT)/60, 0) as cleaned_duration 
		-- en estas dos últimas columnas se extrae el número del string y se convierte en un float reemplazando los NULL por 0
		-- en la última columna se divide por 60 para pasar de minutos a horas
    FROM case02.runner_orders
),
-- Ahora, sacamos lo que pide la pregunta
RunnerOrdersWithSpeed AS (
    SELECT 
        runner_id,
        COALESCE(SUM(cleaned_distance), 0) as total_distance,
        SUM(cleaned_duration) as total_hours,
		-- si cleaned_duration es mayor que 0 se divide, sino se toma como NULL
        AVG(CASE WHEN cleaned_duration > 0 THEN cleaned_distance/cleaned_duration ELSE NULL END) as avg_speed_km_h
    FROM CleanedRunnerOrders
    GROUP BY runner_id
)

SELECT 
    r.runner_id,
    COALESCE(ro.total_distance, 0) as total_distance,
    ro.avg_speed_km_h
FROM case02.runners r
LEFT JOIN RunnerOrdersWithSpeed ro ON r.runner_id = ro.runner_id;
