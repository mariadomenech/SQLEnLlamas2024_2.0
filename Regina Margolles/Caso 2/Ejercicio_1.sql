with CTE_runner_orders_clean 
as 
	(	
		Select
		   order_id, 
			 runner_id,
			 pickup_time,
			 CASE
				  WHEN distance = '' THEN NULL
				  WHEN ISNUMERIC(distance) = 1 THEN distance
				  WHEN PATINDEX('%[A-Za-z]%',distance) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',distance) = 1 THEN TRIM(SUBSTRING(distance,0, CHARINDEX('k',distance)))
			END as distance,
			CASE
				  WHEN duration = '' THEN NULL
				  WHEN ISNUMERIC(duration) = 1 THEN duration
				  WHEN PATINDEX('%[A-Za-z]%',duration) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',duration) = 1 THEN TRIM(SUBSTRING(duration,0, CHARINDEX('m',duration)))
		    END as duration,
			CASE
				  WHEN cancellation = '' THEN NULL
				  WHEN PATINDEX('%null%',cancellation) = 1 THEN NULL
				  WHEN PATINDEX('%[A-Za-z]%',cancellation) = 1 THEN cancellation
		  END as cancellation
				 
	   from case02.runner_orders
	)
	
SELECT r.runner_id,
       ISNULL(distance_per_runner,0), 
       ISNULL(ROUND(total_velocity_per_runner/delivery_number_without_null,2),0) as promedium_velocity_per_runner
       FROM (
					SELECT			
									distinct(runner_id),
									SUM(distance) OVER (PARTITION BY runner_id) AS distance_per_runner,
									SUM(velocity_per_delivery) OVER (PARTITION BY runner_id) as total_velocity_per_runner,
									MIN(delivery_number) OVER (PARTITION BY runner_id) as delivery_number_without_null

					FROM (
					
								SELECT 
									   runner_id,
									   ISNULL(CAST(distance AS decimal(5,2)),0) as distance,
									   COUNT(runner_id) OVER (PARTITION BY runner_id ORDER BY cancellation) as delivery_number,
									   CASE WHEN distance IS NOT NULL AND duration IS NOT NULL 
											THEN 
												CAST(distance AS decimal(5,2))/(CAST(duration AS decimal(5,2))/60)
											ELSE 0
											END AS velocity_per_delivery

								FROM CTE_runner_orders_clean
					) as t
	    GROUP BY runner_id,distance,velocity_per_delivery,delivery_number) as t2

	    right join case02.runners as r 
			on t2.runner_id = r.runner_id;
