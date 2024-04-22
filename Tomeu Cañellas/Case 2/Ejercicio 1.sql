--CASO 2: Ejercicio 1
--Creamos la tabla temporal limpiando los registros
WITH runner_orders AS (
    SELECT  order_id,
            runner_id,
            --Normalizamos los string 'null' con el mismo formato que el resto del campo
            REPLACE(pickup_time, 'null', '0000-00-00 00:00:00') AS pickup_time,
            --Obtenemos el primer carácter que no sea numérico ni . y desechamos el resto de carácteres a la derecha
			      CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + 'x') - 1) AS FLOAT) AS distance_kms,
			      CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + 'x') - 1) AS FLOAT) AS duration_mins,
            --Reemplazamos los valores NULL y 'null' por cadenas vacías
            ISNULL(NULLIF(cancellation, 'null'), '') AS cancellation
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runner_orders] 
)

SELECT  runner_id,
        --Obtenemos la distancia acumulada mediante la suma de km recorridos
		    SUM(distance_kms) AS cum_distance,
        --Para no adulterar la media, reemplazamos los 0 por NULL y calculamos la media de km/h
		    ROUND(AVG(CASE WHEN distance_kms = 0 THEN NULL 
			                 ELSE distance_kms / (duration_mins / 60) END), 2) AS avg_speed
FROM runner_orders
--Agrupamos y ordenamos por corredor
GROUP BY runner_id
ORDER BY runner_id;
