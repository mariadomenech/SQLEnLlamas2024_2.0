--CASO 2: Ejercicio 5
--Creamos la tabla temporal limpiando los registros de runner_orders y seleccionando los campos necesarios
WITH runner_orders AS (
    SELECT  order_id,
            ISNULL(NULLIF(cancellation, 'null'), '') AS cancellation
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[runner_orders] 
),

--Creamos la tabla temporal limpiando los registros de customer_orders y seleccionando los campos necesarios
customer_orders AS (
    SELECT  order_id,
            pizza_id,
            ISNULL(
                CASE WHEN exclusions = 'beef' THEN '3'
                     WHEN exclusions = 'null' THEN ''
                     ELSE exclusions END, ''
            ) AS exclusions,
            ISNULL(
                REPLACE(extras, 'null', ''), ''
            ) AS extras
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[customer_orders]
),

--Separamos los toppings de la tabla pizza_recipes (petición de no utilizar la tabla pizza_recipes_split)
topping_split AS (
    SELECT  pizza_id,
            [1] AS topping_1,
            [2] AS topping_2,
            [3] AS topping_3,
            [4] AS topping_4,
	    [5] AS topping_5,
            [6] AS topping_6,
            [7] AS topping_7,
            [8] AS topping_8
    FROM (
        SELECT  pizza_id,
                Value,
                ROW_NUMBER() OVER (PARTITION BY pizza_id ORDER BY (SELECT NULL)) AS rownumber
        FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_recipes]
        CROSS APPLY STRING_SPLIT(toppings, ',')
    ) AS source_table
    PIVOT (
        MAX(Value) FOR rownumber IN ([1], [2], [3], [4], [5], [6], [7], [8])
    ) AS pivot_table
),

--Obtenemos una tabla con todos los ingredientes que forman las pizzas (tanto los que se añaden como los que se excluyen) separados por columnas
ingredients_table AS (
	SELECT  CAST(topping_1 AS INTEGER) AS topping_1,
		CAST(topping_2 AS INTEGER) AS topping_2,
		CAST(topping_3 AS INTEGER) AS topping_3,
		CAST(topping_4 AS INTEGER) AS topping_4,
		CAST(topping_5 AS INTEGER) AS topping_5,
		CAST(topping_6 AS INTEGER) AS topping_6,
		CAST(ISNULL(topping_7, '')  AS INTEGER) AS topping_7,
		CAST(ISNULL(topping_8, '')  AS INTEGER) AS topping_8,
		CAST(
			CASE WHEN extras LIKE '%,%' THEN LEFT(extras, CHARINDEX(',', extras) - 1)
				 ELSE extras END AS INTEGER) AS extras_1,
		CAST(
			CASE WHEN extras LIKE '%,%' THEN RIGHT(extras, LEN(extras) - CHARINDEX(',', extras))
				 ELSE '' END AS INTEGER) AS extras_2,
		CAST(
			CASE WHEN exclusions LIKE '%,%' THEN LEFT(exclusions, CHARINDEX(',', exclusions) - 1)
				 ELSE exclusions END AS INTEGER) AS exclusions_1,
		CAST(
			CASE WHEN exclusions LIKE '%,%' THEN RIGHT(exclusions, LEN(exclusions) - CHARINDEX(',', exclusions))
				 ELSE '' END AS INTEGER) AS exclusions_2
	FROM runner_orders ro
	INNER JOIN customer_orders co
		ON ro.order_id = co.order_id
	AND ro.cancellation NOT LIKE '%Cancellation%'
	LEFT JOIN topping_split ts
		ON co.pizza_id = ts.pizza_id
),

--Pivotamos la tabla anterior solo con los ingredientes de la pizza y los extras y su cuenta
ingr_plus AS (
	SELECT  id_ingredient,
	   	COUNT(*) AS ingredient_count
	FROM (
		SELECT  topping_1, 
			topping_2, 
			topping_3, 
			topping_4, 
			topping_5, 
			topping_6, 
			topping_7, 
			topping_8, 
			extras_1, 
			extras_2
		FROM ingredients_table
	) AS t
	UNPIVOT (
		id_ingredient FOR colnum IN (topping_1, topping_2, topping_3, topping_4, topping_5, topping_6, topping_7, topping_8, extras_1, extras_2)
	) AS unpvt
	WHERE id_ingredient <> 0
	GROUP BY id_ingredient
),

--Pivotamos la tabla anterior solo con los ingredientes excluidos y su cuenta
ingr_minus AS (
	SELECT  id_ingredient,
		COUNT(*) AS exclusion_count
	FROM (
		SELECT  exclusions_1, 
			exclusions_2
		FROM ingredients_table
	) AS t
	UNPIVOT (
		id_ingredient FOR colnum IN (exclusions_1, exclusions_2)
	) AS unpvt
	WHERE id_ingredient <> 0
	GROUP BY id_ingredient
),

--Restamos los ingredientes excluidos a los de la pizza + extras y obtenemos la cuenta final
ranking AS (
	SELECT  topping_name,
		ISNULL(ingredient_count, 0) - ISNULL(exclusion_count, 0) AS topping_count
	FROM [SQL_EN_LLAMAS_ALUMNOS].[case02].[pizza_toppings] pt
	LEFT JOIN ingr_plus p
		ON p.id_ingredient = pt.topping_id
	LEFT JOIN ingr_minus m
		ON m.id_ingredient = pt.topping_id
)

--Creamos un ranking y agrupamos los ingredientes con la misma cantidad, ordenamos de mayor a menor
SELECT  ROW_NUMBER() OVER (ORDER BY topping_count DESC) AS ranking,
	topping_count,
        STRING_AGG(topping_name, ', ') AS ingredients_list            
FROM ranking
GROUP BY topping_count
;


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está genial, se ve una solución de buen nivel para los problemas que tiene este ejercicio, uno de los más complejos de todos los retos.
Me gusta la limpieza y que cada CTE realiza su proceso de una manera clara.
Por poner algún punto a mejorar la CTE customer_orders se podría haber planteado para casos genéricos en que no estuviera la id y no sólo para el beef,
pero tampoco te lo comenté en el ejercicio 3, con lo que no pasa nada. Y en ingredients_table ocurre una cosa parecida, son soluciones específicas a este
ejercicio pero podrían resolver casos un poco más generales. 
Aún así está todo muy bien. Enhorabuena!! un gran ejercicio! :)

*/
