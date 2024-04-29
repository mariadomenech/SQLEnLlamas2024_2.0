select b.topping_name 
	, COUNT(*) as numero_ocurrencias
FROM
	(
	SELECT 
		VALUE AS VALOR
	FROM
	(
	select 
		coalesce(cast(topping_1 as varchar(2)) ,'')
		+',' + coalesce(cast(topping_2 as varchar(2)),'')
		+',' + coalesce(cast(topping_3 as varchar(2)),'')
		+',' + coalesce(cast(topping_4 as varchar(2)),'')
		+',' + coalesce(cast(topping_5 as varchar(2)),'')
		+',' + coalesce(cast(topping_6 as varchar(2)),'')
		+',' + coalesce(cast(topping_7 as varchar(2)),'')
		+',' + coalesce(cast(topping_8 as varchar(2)),'')
		as TIRA
	from 
		case02.pizza_recipes_split A
	)A
	CROSS APPLY STRING_SPLIT(TIRA, ',')
	) A 
	inner join case02.pizza_toppings b
		on cast(a.VALOR as int)= b.topping_id
	GROUP BY b.topping_name
	order by numero_ocurrencias desc;
