
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

/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado parcialmente incorrecto Dani.

Resultado: En primer lugar, hay que controlar los nulos en el cálculo de la distancia y la duración.
	Además, al calcular la velocidad media, tenemos que manejar el caso de que distancia < 0 como un nulo y no como 0,
	ya que la función AVG omite los valores nulos pero tiene en cuenta los 0, por lo que así alteramos el resultado.
	Por último, no podemos redondear los datos del cálculo de distancia/duracion antes de hacer la media, porque también se alteran aunque sea poco.
	
Código:	Me ha gustado mucho el uso de PATINDEX, una forma ingeniosa y útil para limpiar los datos!
Legibilidad: La segunda CTE podría mejorarse ya que tiene tabulaciones innecesarias (debería de estar al nivel de la anterior CTE), sobre todo en el case when.

Te dejo una forma de aplicar los comentarios:
		with CleanRunner as (
					select 
						runner_id,
						order_id,
						pickup_time,
						COALESCE(CAST(LEFT(distance, PATINDEX('%[^0-9.]%', distance + ' ') - 1) AS FLOAT), 0) as distancia,
						COALESCE(CAST(LEFT(duration, PATINDEX('%[^0-9.]%', duration + ' ') - 1) AS FLOAT)/60, 0)  as duracion
					from case02.runner_orders
					
					),
				
		Runner_Dist_Speed as (
			
					select	
						runner_id,
						coalesce(sum(distancia) ,0)as distancia_total,
						round(avg(case 
								when distancia>0 then distancia/duracion
								else null
							   end),2) velocidad_media
					from CleanRunner
					group by runner_id
		
					)
		
		SELECT 
		    r.runner_id,
			coalesce(distancia_total,0) as distancia_total,
			coalesce(velocidad_media,0) as velocidad_media
		FROM case02.runners r
		LEFT JOIN Runner_Dist_Speed rds ON r.runner_id = rds.runner_id;


Espero que te sirvan los comentarios y mucho ánimo para los siguientes, este es el camino para seguir aprendiendo!!

*/

