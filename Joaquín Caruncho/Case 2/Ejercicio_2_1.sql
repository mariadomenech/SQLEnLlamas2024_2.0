select 
	a.runner_id
	, sum(a.distancia_acumulada) as distancia
	, case when (count(distinct a.order_id) )<>0 then  sum(a.velocidad_media) / (count(distinct a.order_id) ) else 0 end as velocida_promedio

from
(
select
	a.runner_id 
  , a.order_id

	, coalesce(CAST(sum(a.distancia) AS decimal(16,1)),0) distancia_acumulada
	, coalesce(cast( sum(a.distancia)/ sum(a.duracion_horas) as float),0)  as velocidad_media

	
from
		(
		SELECT 
			r.runner_id
			, a.order_id
			, cast (replace(a.distance, 'km','') as decimal (16,4)) as distancia
			,cast(coalesce(trim(replace(replace (replace(a.duration, 'minutes',''),'mins',''), 'minute','')   ),0)as float) /60 as  duracion_horas
			,cast(coalesce(trim(replace(replace (replace(a.duration, 'minutes',''),'mins',''), 'minute','')   ),0)as float)  as  duracion_min
			, duration

		FROM 
			CASE02.runners r
			left join CASE02.runner_orders a
				on a.runner_id = r.runner_id


		WHERE 
			COALESCE(cancellation,'') in ( '', 'null')
	
		)a


group by a.runner_id, order_id

)a
group by a.runner_id
order by a.runner_id;
