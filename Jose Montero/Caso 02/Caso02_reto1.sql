select
	a.order_id
	, a.runner_id
	, coalesce(cast(left(a.distance, patindex('%[^0-9-.]%', a.distance+' ')-1) as float),0) as distancia
	, coalesce(cast(left(a.duration, patindex('%[^0-9-.]%', a.duration+' ')-1) as float),0) as duracion	
into #pedidos
from case02.runner_orders a
group by a.order_id, a.runner_id, a.distance, a.duration

select
	r.runner_id
	, coalesce(sum(p.distancia),0) as Distancia_total
	, round(coalesce((avg(case when p.duracion>0 then p.distancia/(p.duracion/60) else null end)),0),2) as KM_H
from #pedidos p
right join case02.runners r
	on r.runner_id=p.runner_id
group by r.runner_id