CREATE OR ALTER FUNCTION dbo.DistancevsVelocity ()
RETURNS @distance_vs_velocity TABLE 
							(runner_id int,
							 distance_runner decimal(10,5),
							 velocity_runner decimal(10,5))
AS

BEGIN

DECLARE @runner_orders_clean TABLE
			(order_id int, 
			 runner_id int,
			 pickup_time varchar(19),
			 distance varchar(7),
			 duration varchar(10),
			 cancellation varchar(23));


DECLARE @CURSOR CURSOR;
DECLARE @distance_vs_velocity_cursor CURSOR;


DECLARE @order_id int, @runner_id int, @pickup_time varchar(19),@distance varchar(7), @duration varchar(10), @cancellation varchar(23);

DECLARE @pickup_time_value varchar(19); 
DECLARE @distance_value varchar(7);
DECLARE @duration_value varchar(10);
DECLARE @cancellation_value varchar(23);


SET @CURSOR = CURSOR FOR SELECT 
						order_id, 
						runner_id,
						pickup_time,
						distance,
						duration,
						cancellation
						from case02.runner_orders;

OPEN @CURSOR;

FETCH NEXT FROM @CURSOR INTO @order_id, 
							 @runner_id,
							 @pickup_time,
							 @distance,
							 @duration,
							 @cancellation;

	WHILE @@FETCH_STATUS = 0
	BEGIN 
		INSERT INTO @runner_orders_clean 
					(order_id,
					 runner_id)
						 
				VALUES
					(@order_id,
					 @runner_id);

		
		SET @pickup_time_value = 
		    CASE 
				 WHEN ISDATE(@pickup_time) = 1 THEN @pickup_time
				 ELSE NULL
			END;

		SET @distance_value = 
		    CASE
				  WHEN @distance = '' THEN NULL
				  WHEN ISNUMERIC(@distance) = 1 THEN @distance
				  WHEN PATINDEX('%[A-Za-z]%',@distance) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',@distance) = 1 THEN TRIM(SUBSTRING(@distance,0, CHARINDEX('k',@distance)))
			END 

		SET @duration_value =
		    CASE
				  WHEN @duration = '' THEN NULL
				  WHEN ISNUMERIC(@distance) = 1 THEN @duration
				  WHEN PATINDEX('%[A-Za-z]%',@duration) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',@duration) = 1 THEN TRIM(SUBSTRING(@duration,0, CHARINDEX('m',@duration)))
		    END

		SET @cancellation_value =
		    CASE
				  WHEN @duration = '' THEN NULL
				  WHEN PATINDEX('%null%',@cancellation) = 1 THEN NULL
				  WHEN PATINDEX('%[A-Za-z]%',@cancellation) = 1 THEN @cancellation
		    END

		UPDATE @runner_orders_clean 
		       SET pickup_time = @pickup_time_value,
			       distance = @distance_value,
				   duration = @duration_value,
				   cancellation = @cancellation_value
			   WHERE order_id = @order_id
			    and  runner_id = @runner_id;
			
		FETCH NEXT FROM @CURSOR INTO @order_id, 
									 @runner_id,
									 @pickup_time,
									 @distance,
									 @duration,
									 @cancellation;

		
	
	END

CLOSE @CURSOR;
DEALLOCATE @CURSOR;

INSERT INTO @distance_vs_velocity (runner_id,distance_runner,velocity_runner) 
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

								FROM @runner_orders_clean
						  ) as t
					GROUP BY runner_id,distance,velocity_per_delivery,delivery_number) as t2

		right join case02.runners as r on t2.runner_id = r.runner_id;



RETURN

END;

select * from dbo.DistancevsVelocity();

