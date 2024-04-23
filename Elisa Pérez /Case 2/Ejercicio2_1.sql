WITH tmp AS(
	SELECT	O.order_id
			    , R.runner_id
			    , CAST(IIF(O.distance='null', NULL,REPLACE(O.distance, 'km', ''))AS decimal(4,2)) distance
			    , CAST(IIF(O.duration='null', NULL, TRIM('minutes ' FROM O.duration))AS decimal(4,2)) duration
	FROM case02.runner_orders O
	RIGHT JOIN case02.runners R
	ON O.runner_id = R.runner_id
)
SELECT	runner_id
		    , ISNULL(SUM(distance), 0) distancia_acum
		    , ISNULL(CAST(AVG(distance/duration)AS decimal(4,2)), 0)  velocidad_avg
FROM tmp
GROUP BY runner_id;
