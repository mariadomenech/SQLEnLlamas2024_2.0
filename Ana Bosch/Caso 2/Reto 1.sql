-- Reto 1: ¿Cuál es la distancia acumulada de reparto de cada runner? ¿Y la velocidad promedio en Km/h?

with clean_CTE
as
(
	select order_id
		,runner_id
		,try_cast(case	when patindex('%[A-Za-z]%', distance) > 0 then stuff(distance, patindex('%[A-Za-z]%', distance), len(distance), '')	else distance end as decimal(5,1)) as distance
		,try_cast(case when patindex('%[A-Za-z]%', duration) > 0 then stuff(duration, patindex('%[A-Za-z]%', duration), len(duration), '') else duration end as decimal(5,1)) as duration
	from case02.runner_orders
),

calculate_CTE
as
(
	select B.runner_id
		,distance
		,distance/(duration/60) as speed 
	from clean_CTE A
	right join case02.runners B
		on A.runner_id = B.runner_id
)

select runner_id
	,coalesce(sum(distance), 0) as sum_distance
	,coalesce(cast(avg(speed) as decimal(5,2)), 0) as avg_speed
from calculate_CTE
group by runner_id

-- Se podría haber aprovechado la primera CTE para hacer los cálculos también en ella, no obstante he preferido dividirlo en dos para dejar claro que en cada una ocurren procesos diferentes 


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto! Por mi parte también prefiero que se haga en 2 CTEs, así se ven los dos procesos por separado y en caso de necesitar cambiar algo es más fácil de leer.
Me gusta mucho el uso del PATINDEX, muy original y sobre todo del stuff, así que me lo apunto para mi :)
También el tener en cuenta que estén todos los runners, no sólo los que hacen pedidos, así como los casteos y control de nulos. Es un ejercicio perfecto.

Como única cosa por decirte algo hubiera tabulado un poco más los CASE para mejorar la legibilidad, pero sin más.

Ánimo con el siguiente! :)

*/
