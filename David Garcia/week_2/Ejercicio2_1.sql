
with CleanRunner as (

	select 
		runner_id,
		order_id,
		pickup_time,
		cast(left(distance, PATINDEX('%[^0-9.]%', distance + ' ') - 1) as float) as distancia,
		round(cast(left(duration, PATINDEX('%[^0-9.]%', duration + ' ') - 1) as float)/60 ,2)  as duracion
	from case02.runner_orders
	
	),

Runner_Dist_Speed as (
	
			select	
				runner_id,
				sum(distancia) as distancia_total,
				avg(case 
							when distancia>0 then round(distancia/duracion, 2)
							else 0
					end) velocidad_media
			from CleanRunner
			group by runner_id

	)

	SELECT 
    r.runner_id,
	  coalesce(distancia_total,0) as distancia_total,
	  coalesce(velocidad_media,0) as velocidad_media
	FROM case02.runners r
  LEFT JOIN Runner_Dist_Speed rds ON r.runner_id = rds.runner_id
