
select 
sum(co.precio_pizza) ingreso_pizzas
,sum(ex.extra_por_pedido) extras
,sum(ro.distancia_coste) as costes
,sum(co.precio_pizza) + sum(ex.extra_por_pedido)- sum(ro.distancia_coste) as resultado_final
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
/*COMENTARIOS JUANPE:
Genial por incluir beneficios que era realmente lo que se pedia aunque por error la app no lo mostroba. 
Bien visto la función STRING_SPLIT
Es totalmente correcto el uso de varias subselect pero si me aceptas un consejo mira el uso de las cte, son las tablas temporales que se usan con el with
suelen ser muy comodas y su uso suele llevar asociado un código más ordenado y limpio, pero como lo tienes con subselect como te digo también es valido,
aunque mejorable la limpieza de código, pero por lo demás todo bien.*/
