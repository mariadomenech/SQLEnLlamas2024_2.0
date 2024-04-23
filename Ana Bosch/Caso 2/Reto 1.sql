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
