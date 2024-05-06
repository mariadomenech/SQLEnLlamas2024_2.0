WITH runner_orders_temp AS(
	SELECT
		runner_id,
		order_id,
		pickup_time,
		COALESCE(SUM(CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + ' ') -1 ) AS FLOAT)), 0) as distance, --Nos quedamos solo con la parte numérica del campo y la convertimos en float
		COALESCE(SUM(CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + ' ') -1 ) AS FLOAT))/60, 0) as duration --Igual que el anterior, pero además dividimos por 60 para quedarnos con las horas
	FROM case02.runner_orders 
	GROUP BY runner_id,
		order_id,
		pickup_time
)

SELECT
	runners.runner_id,
	COALESCE(SUM(distance),0) as distancia_acumulada_km, --Evitamos los nulos poniendo un 0 en su lugar
	ROUND(COALESCE(AVG( CASE WHEN duration > 0 THEN distance/duration
						ELSE NULL END), 0), 4) as velocidad_promedio_km_h --Redondeamos a 4 decimales y evitamos la división por 0
FROM runner_orders_temp runner_orders
RIGHT JOIN case02.runners runners
		ON (runner_orders.runner_id = runners.runner_id)

GROUP BY runners.runner_id;

/*Comentarios Juanpe
Todo Correcto resultados legiblidad y código y bien limpiando los datos iniciales*/
