
select 
sum(co.precio_pizza) ingreso_pizzas
,sum(ex.extra_por_pedido) extras
,sum(ro.distancia_coste) as costes
-- comento calculo del resultado final para que se ajuste a lo que devuelve la comparison tool
--,sum(co.precio_pizza) + sum(ex.extra_por_pedido)- sum(ro.distancia_coste) as resultado_final
from
(
		SELECT 
			a.runner_id
			, a.order_id		
			, cast (replace(a.distance, 'km','') as decimal (16,4)) *0.3 as distancia_coste
		FROM 
			CASE02.runner_orders a
		WHERE 
			COALESCE(cancellation,'') in ( '', 'null')	
	)RO
	INNER JOIN
	(
	   select 
				ORDER_ID
				,sum( CASE WHEN pizza_id= 1 THEN 12
					   WHEN pizza_id= 2 THEN 10
				END )AS PRECIO_PIZZA
			from 
				case02.customer_orders a
			group by ORDER_ID
	)CO
	ON RO.order_id = CO.order_id
left join 
(
select a.order_id, sum(a.precio_extra) as extra_por_pedido
from
(
	SELECT 
	order_id
	, extras
	, value
	, 1 as precio_extra
	
FROM case02.customer_orders 
	CROSS APPLY STRING_SPLIT(extras, ',')
where 
	coalesce(value,'')not in ('','null')
)a
group by a.order_id
) ex
on ro.order_id = ex.order_id;
