-- RETO 5. ¿CUÁNTAS VECES HA SIDO USADO CADA INGREDIENTE SOBRE EL TOTAL DE PIZZAS ENTREGADAS
-- CON ÉXITO? ORDENA DESDE EL MÁS FRECUENTE AL MENOS FRECUENTE UTILIZANDO LA TABLA PIZZA_RECIPES.
-- NOTA: Es verdad que se podría hacer en menos CTEs, pero he preferido que fuese un poco más legible :D
;WITH
	RUNNER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,CASE
				WHEN LOWER(cancellation) IN ('', 'null') THEN NULL
				ELSE cancellation
			END AS cancellation
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	)

	,CUSTOMER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,pizza_id
			,NULLIF(NULLIF(exclusions, ''), 'null') AS exclusions
			,NULLIF(NULLIF(extras, ''), 'null') AS extras
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders
	)

	,SUCCESSFUL_ORDERS_PIZZAS AS (
		SELECT
			co.order_id
			,co.pizza_id
			,co.exclusions
			,co.extras
		FROM RUNNER_ORDERS_CLEANED AS ro
		LEFT JOIN CUSTOMER_ORDERS_CLEANED AS co
			ON ro.order_id = co.order_id
		WHERE ro.cancellation IS NULL
	)

	,PIZZA_RECIPES_SPLIT AS (
		SELECT
			pizza_id
			,CAST(TRIM(topp.value) AS int) AS topping_id
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_recipes
			CROSS APPLY STRING_SPLIT(toppings,',') AS topp
	)

	,EXCLUDED_TOPPINGS AS (
		SELECT ISNULL(pt.topping_id, TRIM(exclusions_cleaned.value)) AS excluded_topping_id
		FROM SUCCESSFUL_ORDERS_PIZZAS AS sop
			CROSS APPLY STRING_SPLIT(sop.exclusions,',') AS exclusions_cleaned
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings AS pt
			ON TRIM(exclusions_cleaned.value) = LOWER(pt.topping_name)
	)

	,EXTRA_TOPPINGS AS (
		SELECT ISNULL(pt.topping_id, TRIM(extras_cleaned.value)) AS extra_topping_id
		FROM SUCCESSFUL_ORDERS_PIZZAS AS sop
			CROSS APPLY STRING_SPLIT(sop.extras,',') AS extras_cleaned
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings AS pt
			ON TRIM(extras_cleaned.value) = LOWER(pt.topping_name)
	)

	,EXCLUDED_TOPPINGS_COUNT AS (
		SELECT
			excluded_topping_id
			,COUNT(*) AS exclusion_counter
		FROM EXCLUDED_TOPPINGS
		GROUP BY excluded_topping_id
	)

	,EXTRA_TOPPINGS_COUNT AS (
		SELECT
			extra_topping_id
			,COUNT(*) AS extra_counter
		FROM EXTRA_TOPPINGS
		GROUP BY extra_topping_id
	)

	,STANDARD_TOPPINGS_COUNT AS (
		SELECT
			prs.topping_id AS standard_topping_id
			,COUNT(*) AS standard_counter
		FROM SUCCESSFUL_ORDERS_PIZZAS AS sop
		LEFT JOIN PIZZA_RECIPES_SPLIT AS prs
			ON sop.pizza_id = prs.pizza_id
		GROUP BY prs.topping_id
	)

	,NET_TOPPINGS_COUNT AS (
		SELECT
			pt.topping_name
			,ISNULL(standard_c.standard_counter, 0) AS standard_counter
			,ISNULL(excluded_c.exclusion_counter, 0) AS exclusion_counter
			,ISNULL(extra_c.extra_counter, 0) AS extra_counter
			,ISNULL(standard_c.standard_counter, 0) -
				ISNULL(excluded_c.exclusion_counter, 0) +
				ISNULL(extra_c.extra_counter, 0) AS usage_counter
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings AS pt
		LEFT JOIN EXCLUDED_TOPPINGS_COUNT AS excluded_c
			ON pt.topping_id = excluded_c.excluded_topping_id
		LEFT JOIN EXTRA_TOPPINGS_COUNT AS extra_c
			ON pt.topping_id = extra_c.extra_topping_id
		LEFT JOIN STANDARD_TOPPINGS_COUNT AS standard_c
			ON pt.topping_id = standard_c.standard_topping_id
	)

	,TOPPINGS_RANKING AS (
		SELECT
			DENSE_RANK() OVER (ORDER BY usage_counter DESC) AS ranking
			,usage_counter
			,STRING_AGG(topping_name, ', ')
				WITHIN GROUP (ORDER BY usage_counter DESC) AS topping_names
		FROM NET_TOPPINGS_COUNT
		GROUP BY usage_counter
	)

SELECT *
FROM TOPPINGS_RANKING;
