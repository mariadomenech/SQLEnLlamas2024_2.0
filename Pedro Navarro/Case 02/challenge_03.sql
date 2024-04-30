-- RETO 3. UNA PIZZA MEAT LOVERS CUESTA 12 EUROS Y UNA VEGERARIANA 10 EUROS, Y CADA INGREDIENTE
-- EXTRA SUPONE UN 1 EURO ADICIONAL. POR OTRO LADO, A CADA CORREDOR SE LE PAGA
-- 0.30 EUROS/KM RECORRIDO. ¿CUÁNTO DINERO LE SOBRA A GIUSEPPE DESPUÉS DE ESTAS ENTREGAS?
DECLARE @meatlover_pizza_price INT, @vegetarian_pizza_price INT, @extra_ingredient_price INT, @runner_eur_km NUMERIC(5,2);
SET @meatlover_pizza_price = 12;
SET @vegetarian_pizza_price = 10;
SET @extra_ingredient_price = 1;
SET @runner_eur_km = 0.30;

;WITH
	CUSTOMER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,customer_id
			,pizza_id
			,NULLIF(NULLIF(exclusions, ''), 'null') AS exclusions
			,NULLIF(NULLIF(extras, ''), 'null') AS extras
			,order_time
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders
	)

	,RUNNER_ORDERS_CLEANED AS (
		SELECT
			order_id
			,runner_id
			,CAST(NULLIF(pickup_time, 'null') AS DATETIME) AS pickup_time
			,CAST(
				CASE
					WHEN PATINDEX('%k%m%', distance) > 0 
						THEN TRIM(SUBSTRING(distance, 1, PATINDEX('%k%m%', distance)-1))
					ELSE REPLACE(LOWER(TRIM(distance)), 'null', 0)
				END AS FLOAT) AS distance_in_km
			,CAST(
				CASE
					WHEN PATINDEX('%min%', duration) > 0 
						THEN TRIM(SUBSTRING(duration, 1, PATINDEX('%min%', duration)-1))
					ELSE REPLACE(LOWER(TRIM(duration)), 'null', 0)
				END AS FLOAT) AS duration_in_min
			,CASE
				WHEN cancellation IN ('', 'null') THEN NULL
				ELSE cancellation
			END AS cancellation
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	)

	,SUCCESSFUL_ORDERS_OBT AS (
		SELECT
			co.order_id
			,co.customer_id
			,co.pizza_id
			,co.exclusions
			,co.extras
			,co.order_time
			,ro.runner_id
			,ro.pickup_time
			,ro.distance_in_km
			,ro.duration_in_min
			,ro.cancellation
		FROM CUSTOMER_ORDERS_CLEANED AS co
		LEFT JOIN RUNNER_ORDERS_CLEANED AS ro
			ON co.order_id = ro.order_id
		WHERE ro.cancellation IS NULL
	)

	,PIZZAS_REVENUE AS (
		SELECT
			obt.order_id
			,SUM(
				CASE
					WHEN pn.pizza_name LIKE 'Meatlovers' THEN @meatlover_pizza_price
					WHEN pn.pizza_name LIKE 'Vegetarian' THEN @vegetarian_pizza_price
					ELSE 0
				END) AS revenue_from_pizzas_in_euros
		FROM SUCCESSFUL_ORDERS_OBT AS obt
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case02.pizza_names AS pn
			ON obt.pizza_id = pn.pizza_id
		GROUP BY obt.order_id
	)

	,EXTRAS_REVENUE AS (
		SELECT
			order_id
			,COUNT(ext.value)*@extra_ingredient_price AS revenue_from_extras_in_euros
		FROM SUCCESSFUL_ORDERS_OBT AS obt
			CROSS APPLY STRING_SPLIT(obt.extras, ',') AS ext
		GROUP BY order_id
	)

	,RUNNERS_COST AS (
		SELECT
			order_id
			,SUM(distance_in_km*@runner_eur_km) AS cost_from_runners_in_euros
		FROM RUNNER_ORDERS_CLEANED
		GROUP BY order_id
	)

	,GIUSEPPE_HERITAGE AS (
		SELECT
			SUM(ISNULL(p.revenue_from_pizzas_in_euros, 0)) AS total_revenue_from_pizzas_in_euros
			,SUM(ISNULL(e.revenue_from_extras_in_euros, 0)) AS total_revenue_from_extras_in_euros
			,SUM(ISNULL(r.cost_from_runners_in_euros, 0)) AS total_cost_from_runners_in_euros
			,SUM(ISNULL(p.revenue_from_pizzas_in_euros, 0)) +
				SUM(ISNULL(e.revenue_from_extras_in_euros, 0)) -
				SUM(ISNULL(r.cost_from_runners_in_euros, 0)) AS giuseppe_heritage_in_euros
		FROM PIZZAS_REVENUE AS p
		LEFT JOIN EXTRAS_REVENUE AS e
			ON p.order_id = e.order_id
		LEFT JOIN RUNNERS_COST AS r
			ON p.order_id = r.order_id
	)

SELECT *
FROM GIUSEPPE_HERITAGE;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Perfecta.

Genial Pedro! Me ha gustado mucho el detalle de declarar variables para los precios y las constantes, es una muy
buena práctica para no repetir código y de cara al futuro si hubiera que modificar las mismas. 

Como siempre muy bien la creación de las CTEs para que sea más fácil y claro  seguir la query.
Además, muy bien usado el STRING_SPLIT para separar los extras y calcular el beneficio de los mismos.

A seguir así!
*/



