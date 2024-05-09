WITH ing_extras AS(
	SELECT 
		topping_id,
		topping_name,
		COUNT(extras) as veces_extras
	FROM (
		SELECT 
			CASE 
				WHEN TRIM(value) = 'null' OR TRIM(value) = '' THEN 0 
				WHEN TRY_CAST(TRIM(value) AS INT) IS NULL THEN 0 
				ELSE TRY_CAST(TRIM(value) AS INT) 
			END AS extras
		FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(extras, ',') 
		WHERE order_id NOT IN (
			SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%'
		)
	) consulta
	JOIN case02.pizza_toppings pt 
		ON consulta.extras = pt.topping_id 
	WHERE extras != 0 
	GROUP BY topping_id, topping_name
),

ing_exclusions AS(
	SELECT 
		topping_id,
		topping_name,
		COUNT(exclusions) as veces_exclusions
	FROM (
		SELECT 
			CASE 
				WHEN TRIM(value) = 'null' OR TRIM(value) = '' THEN 0 
				WHEN TRIM(value) = 'beef' THEN 3 
				WHEN TRY_CAST(TRIM(value) AS INT) IS NULL THEN 0 
				ELSE TRY_CAST(TRIM(value) AS INT) 
			END AS exclusions
		FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(exclusions, ',') 
		WHERE order_id NOT IN (
			SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%'
		)
	) consulta
	JOIN case02.pizza_toppings pt 
		ON consulta.exclusions = pt.topping_id 
	WHERE exclusions != 0 
	GROUP BY topping_id, topping_name
),

ing_pizzas_ok AS(
	SELECT
		pt.topping_id as topping_id,
		pt.topping_name as topping_name,
		count(*) as veces_ingredientes
	FROM(
		SELECT 
			co.order_id,
			co.pizza_id,
			TRIM(val1.value) AS toppings
		FROM case02.customer_orders co
		JOIN case02.pizza_recipes pr 
			ON co.pizza_id = pr.pizza_id
		CROSS APPLY STRING_SPLIT(toppings, ',') as val1
		WHERE co.order_id NOT IN (
			SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%'
		)
	) consulta
	JOIN case02.pizza_toppings pt 
		ON toppings = pt.topping_id
	GROUP BY pt.topping_id, pt.topping_name
),

ing_total AS(
	SELECT 
		pt.topping_name,
		SUM(COALESCE(veces_ingredientes,0) + COALESCE(veces_extras, 0) - COALESCE(veces_exclusions,0)) AS num_ingredientes_gen
	FROM case02.pizza_toppings pt 
	LEFT JOIN ing_pizzas_ok	ipo 
		ON pt.topping_id = ipo.topping_id
	LEFT JOIN ing_extras iextras
		ON pt.topping_id = iextras.topping_id
	LEFT JOIN ing_exclusions iexclusions
		ON pt.topping_id = iexclusions.topping_id
	GROUP BY pt.topping_name
)

SELECT
	RANK() OVER (ORDER BY num_ingredientes_gen DESC) AS ranking,
	num_ingredientes_gen,
	STRING_AGG(topping_name, ', ') AS ingredientes
FROM ing_total
GROUP BY num_ingredientes_gen
ORDER BY ranking;
;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Resultado correcto!

*/
