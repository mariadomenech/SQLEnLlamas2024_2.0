--¿Cuántas veces ha sido usado cada ingrediente sobre el total de pizzas entregas con éxito? Ordena desde el más frecuenta al menos frecuente.
-- Se debe utilizar la tabla PIZZA_RECIPES

-- Se obtiene los ingredientes de cada pizza con los extras de cada pedido satisfactorio.
WITH base_con_extras AS(
	SELECT TRIM (VALUE) AS cod_ingredientes 
    , COUNT(*) AS num_ingredientes
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders run
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders cus
		ON run.order_id = cus.order_id
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case02.pizza_recipes topp
		ON cus.pizza_id = topp.pizza_id
	CROSS APPLY STRING_SPLIT ( CONCAT (topp.toppings , ',', (CASE WHEN (extras is null OR extras = 'null' or extras = '') THEN '' ELSE extras END) ),',')
	WHERE (cancellation is null OR cancellation = 'null' or cancellation = '') 
    AND TRIM (VALUE) <> ''
	GROUP BY TRIM (VALUE)
),

base_final_pizzas AS(
	-- Restamos los ingredientes extras y base con los que se excluyen, además de obtener el nombre de cada uno de ellos.
	SELECT (base.num_ingredientes - COALESCE(extra.num_excluidos,0) ) AS num_uso_ingredientes
		, topp.topping_name AS des_nombre_topping
	FROM base_con_extras base
	INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings topp
		ON base.cod_ingredientes = topp.topping_id
	LEFT JOIN 
	(	-- Se obtienen todos los ingredientes excluidos de cada pedido satisfactorio.
		SELECT TRIM(value) AS cod_excluidos
			, COUNT(*) AS num_excluidos
		FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders ord
		INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders run
			ON ord.order_id = run.order_id
			CROSS APPLY STRING_SPLIT(( CASE WHEN (ord.exclusions is null OR ord.exclusions = 'null' or ord.exclusions = '') THEN '0'
					                            WHEN (ord.exclusions = 'beef') THEN '3'
					                            ELSE ord.exclusions END), ',') 
		WHERE TRIM(value) <> '0' 
		  AND (run.cancellation is null OR run.cancellation = 'null' or run.cancellation = '')
		GROUP BY TRIM(value)
	) extra
		ON base.cod_ingredientes = extra.cod_excluidos
)

-- Agrupamos por número de veces que utiliza cada ingrediente agrupando el nombre de cada uno e indicando el orden de frecuencia.
SELECT RANK() OVER (ORDER BY num_uso_ingredientes DESC) AS id_frecuencia
	, num_uso_ingredientes
	, STRING_AGG(des_nombre_topping, ', ') AS des_nombre_topping
FROM base_final_pizzas
GROUP BY num_uso_ingredientes
ORDER BY 1;



/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Perfecto Cristina, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Me gusta mucho lo organizado que lo haces y las explicaciones para facilitar la corrección!


*/
