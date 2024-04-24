select 
	  a.runner_id
	, a.num_pedidos_exito
	, a.num_pizzas_exito
	,  cast(case when a.total_pedidos = 0 then 0 else cast(a.num_pedidos_exito  as decimal(16,2))/ a.total_pedidos *100 end  as decimal(16,2))as porcentaje_exito
	,  cast(case when a.total_pizzas = 0 then 0 else cast(a.pizza_con_modificaciones  as decimal(16,2))/ a.num_pizzas_exito *100 end as decimal(16,2))as  porcentaje_pizza_modificaciones

from
(

select 
	r.runner_id
	, count (distinct case when coalesce(a.cancellation,'') not like '%cancellation%' then a.order_id end ) as num_pedidos_exito
	, count(distinct a.order_id) as total_pedidos
	, sum (case when b.pizza_id is not null and  coalesce(a.cancellation,'')  not like '%cancellation%' then 1 else 0 end ) as num_pizzas_exito
	, coalesce(sum(case when b.pizza_id is not null
				and  coalesce(a.cancellation,'')  not like '%cancellation%' 
				and (COALESCE(b.exclusions ,'') not in ( '', 'null')	
				or COALESCE(b.extras ,'') not in ( '', 'null'))	 then 1 end ),0) as pizza_con_modificaciones
	, coalesce(count(b.pizza_id),0) as total_pizzas
	FROM 
		CASE02.runners r
		left join CASE02.runner_orders a
			on a.runner_id = r.runner_id
		left join case02.customer_orders b
			on a.order_id = b.order_id
	group by r.runner_id

)a
order by a.runner_id;
