WITH CTE_CLEAN AS(
	SELECT A.runner_id runner,
		CASE WHEN PATINDEX('%[A-z]%', B.distance) > 0 THEN
			CAST(LEFT(B.distance, PATINDEX('%[A-z]%', B.distance) - 1) AS FLOAT)
			ELSE ISNULL(CAST(B.distance AS FLOAT), 0)
		END distance,
		CASE WHEN PATINDEX('%[a-z]%', B.duration) > 0 THEN
			CAST(LEFT(B.duration, PATINDEX('%[a-z]%', B.duration) - 1) AS FLOAT)
		ELSE ISNULL(CAST(B.duration AS FLOAT), 0)
		END duration
	FROM case02.runners A
	LEFT JOIN case02.runner_orders B
		ON A.runner_id = B.runner_id
)
SELECT runner,
  CONCAT(SUM(distance), 'km') total_dist,
  CONCAT(ISNULL(CAST(AVG(distance / NULLIF(duration / 60, 0))AS DECIMAL(5,2)),0), 'km/h') avg_vel
FROM CTE_CLEAN
GROUP BY runner;
