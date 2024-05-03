
select 
	RANK() OVER (ORDER BY A.TOTAL DESC) AS ranking 
	,a.total as num_ingredientes
	, STRING_AGG(A.TOPPING_NAME, ', ') WITHIN GROUP ( ORDER BY A.TOTAL  DESC) as ingredientes
	from
	(
	select 
		a.topping_name
		, total
	from
		(
		select 
			   a.topping_name
			   , a.conteo + coalesce(c.sumar ,0) - coalesce (b.restar, 0) as total
		from
		(
			   select 
					 c.topping_name
					 , c.topping_id 
					 , COUNT(*) as conteo
			   FROM
			   (
			   select 
					 pizza_id
					 , exclusions
					 , EXTRAS
			   from
					 CASE02.runner_orders a
							left join case02.customer_orders b
								  on a.order_id = b.order_id
								  where 
									coalesce(a.cancellation,'')  not like '%cancellation%' 										
					 ) A
			   inner join
			   (
			   select 
					pizza_id
					, CAST(TRIM(VALUE) AS INT) AS VALOR
				from
					case02.pizza_recipes a
					CROSS APPLY STRING_SPLIT(toppings, ',')
			   )b
			   on a.pizza_id = b.pizza_id
			   inner join 
  				case02.pizza_toppings c
			   on 
				  b.VALOR = c.topping_id
			   group by c.topping_name, c.topping_id
			   )a
			   -- exclusiones
			   left join
			   (
			   select 
					coalesce (c.topping_id, a.valor) as topping_id
					, count(*) as restar
			   from
			   (
			   select 
					pizza_id
					, exclusions
					, trim(value )  valor
			   from
			   CASE02.runner_orders a
				left join case02.customer_orders b
					on a.order_id = b.order_id
						CROSS APPLY STRING_SPLIT(b.exclusions, ',')
				where 
					coalesce(a.cancellation,'')  not like '%cancellation%' 
					and (COALESCE(b.exclusions ,'') not in ( '', 'null')      
					)
			)a
			left join case02.pizza_toppings c
				on a.valor= c.topping_name
			group by coalesce (c.topping_id, a.valor) 
		)b
		on a.topping_id = b.topping_id
		-- extras
		left join
		(
		select a.valor as topping_id, count(*) as sumar
		from
		(
		select pizza_id, extras, trim(value )  valor
		from
		CASE02.runner_orders a
					left join case02.customer_orders b
							on a.order_id = b.order_id
					CROSS APPLY STRING_SPLIT(b.extras, ',')
					where 
									coalesce(a.cancellation,'')  not like '%cancellation%' 
									and (COALESCE(b.extras ,'') not in ( '', 'null')      
									)
				)a
    group by a.valor
		)c
		on a.topping_id = c.topping_id
	)a
)a
GROUP BY A.total
ORDER BY TOTAL DESC;
