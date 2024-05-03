SELECT 
DENSE_RANK( ) OVER (ORDER BY gasto_ingredientes DESC) AS ranking,
gasto_ingredientes AS num_ingredientes,
STRING_AGG(topping_name,', ') WITHIN GROUP (ORDER BY topping_id) AS ingredientes
FROM
	(SELECT 
		A.topping_id,
		topping_name, 
		COUNT(A.topping_id) + ISNULL(CAST(N_extras AS INT),0) - ISNULL(CAST(N_exclusiones AS INT),0) AS gasto_ingredientes
	FROM case02.pizza_recipes_split
	UNPIVOT (topping_id FOR Nombre IN ([topping_1],[topping_2],[topping_3],[topping_4],[topping_5],[topping_6],[topping_7],[topping_8])) AS A
	INNER JOIN case02.pizza_toppings B
		ON (A.topping_id=B.topping_id)
	INNER JOIN (
		SELECT 
			order_id,
			customer_id,
			pizza_id,
			CASE	
				WHEN exclusions IN ('',' ','null','NULL') THEN NULL
				WHEN UPPER(exclusions) in ('BEEF') THEN '5'
				ELSE REPLACE(exclusions,' ' ,'')
			END exclusions,
			CASE	
				WHEN extras IN ('',' ','null','NULL') THEN NULL
				ELSE REPLACE(extras,' ','')
			END extras,
			order_time
		FROM case02.customer_orders
	) C
		ON (A.pizza_id=C.pizza_id)
	INNER JOIN (
		SELECT 
			order_id,
			runner_id,
			pickup_time,
			distance,
			duration,
			CASE	
				WHEN cancellation IN ('',' ','null','NULL') THEN NULL
				ELSE cancellation
			END cancellation
		FROM case02.runner_orders
	) D
		ON (C.order_id=D.order_id)
	LEFT JOIN (SELECT
					[value] AS topping_id, 
					COUNT([value]) AS N_extras
				FROM (
					SELECT 
						order_id,
						customer_id,
						pizza_id,
						CASE	
							WHEN exclusions IN ('',' ','null','NULL') THEN NULL
							WHEN UPPER(exclusions) in ('BEEF') THEN '5'
							ELSE REPLACE(exclusions,' ' ,'')
						END exclusions,
						CASE	
							WHEN extras IN ('',' ','null','NULL') THEN NULL
							ELSE REPLACE(extras,' ','')
						END extras,
						order_time
					FROM case02.customer_orders
				) AS A
				CROSS APPLY STRING_SPLIT(extras,',') AS B
				INNER JOIN (
					SELECT 
						order_id,
						runner_id,
						pickup_time,
						distance,
						duration,
						CASE	
							WHEN cancellation IN ('',' ','null','NULL') THEN NULL
							ELSE cancellation
						END cancellation
					FROM case02.runner_orders
				) C
					ON (A.order_id=C.order_id)
				WHERE cancellation IS NULL
				GROUP BY [value]
				) E
		ON (B.topping_id=E.topping_id)
	LEFT JOIN (
				SELECT
					[value] AS topping_id, 
					COUNT([value]) AS N_exclusiones
				FROM (
					SELECT 
						order_id,
						customer_id,
						pizza_id,
						CASE	
							WHEN exclusions IN ('',' ','null','NULL') THEN NULL
							WHEN UPPER(exclusions) in ('BEEF') THEN '5'
							ELSE REPLACE(exclusions,' ' ,'')
						END exclusions,
						CASE	
							WHEN extras IN ('',' ','null','NULL') THEN NULL
							ELSE REPLACE(extras,' ','')
						END extras,
						order_time
					FROM case02.customer_orders
				) AS A
				CROSS APPLY STRING_SPLIT(exclusions,',') AS B
				INNER JOIN (
					SELECT 
						order_id,
						runner_id,
						pickup_time,
						distance,
						duration,
						CASE	
							WHEN cancellation IN ('',' ','null','NULL') THEN NULL
							ELSE cancellation
						END cancellation
					FROM case02.runner_orders
				) C
					ON (A.order_id=C.order_id)
				WHERE cancellation IS NULL
				GROUP BY [value]
				) F
		ON (B.topping_id=F.topping_id)
	WHERE cancellation IS NULL
	GROUP BY A.topping_id,topping_name,N_extras,N_exclusiones
) G
GROUP BY gasto_ingredientes;
