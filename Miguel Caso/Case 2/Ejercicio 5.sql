WITH temp_customer_orders AS (
    SELECT 
	ORDER_ID,
    CUSTOMER_ID,
    PIZZA_ID,
    CASE EXCLUSIONS
        WHEN 'beef' THEN '3'
        WHEN 'null' THEN ''
        ELSE COALESCE (EXCLUSIONS, '')
        END AS exclusions,
    CASE EXTRAS
        WHEN 'null' THEN ''
        ELSE COALESCE (EXTRAS, '')
        END AS extras,
    ORDER_TIME
    FROM SQL_EN_LLAMAS_ALUMNOS.case02.CUSTOMER_ORDERS),
temp_runner_orders AS (
    SELECT ORDER_ID,
    RUNNER_ID,
    CASE PICKUP_TIME
        WHEN 'null' THEN ''
        ELSE PICKUP_TIME
        END AS pickuptime,
    CAST (CASE
        WHEN distance='null' THEN ''
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN distance
        ELSE STUFF(distance, PATINDEX('%[^1234567890.]%', distance),10,'')
        END AS decimal (10,2)) AS distance,
    CAST (CASE
        WHEN PATINDEX('%[^1234567890.]%', duration) =0 THEN duration
        ELSE STUFF(duration, PATINDEX('%[^1234567890.]%', duration),10,'')
        END AS decimal (10,2)) AS duration,
    CASE CANCELLATION
        WHEN 'null' THEN ''
        ELSE COALESCE(CANCELLATION, '')	
        END AS cancellation
FROM SQL_EN_LLAMAS_ALUMNOS.case02.RUNNER_ORDERS ),

/* Contamos los ingredientes de los pedidos no cancelados, y añadimos al listado los extras que se hayan añadido */
pedidos_a_ingredientes AS (
	SELECT
		co.order_id,
		pr.toppings AS topping
	FROM temp_customer_orders co
		LEFT JOIN temp_runner_orders ro ON co.order_id = ro.order_id
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case02.PIZZA_RECIPES pr ON co.pizza_id = pr.pizza_id
	WHERE ro.cancellation =''
	UNION ALL
	SELECT
		co.order_id,
		co.extras AS topping
	FROM temp_customer_orders co
		LEFT JOIN temp_runner_orders ro ON co.order_id = ro.order_id
		WHERE ro.cancellation ='' AND co.extras<>''),

/* Partiendo de la anterior, creamos una lista con una línea por ingrediente */
lista_ingredientes AS (
	SELECT
		pai.order_id,
		TRIM (value) AS topping
	FROM pedidos_a_ingredientes pai
		CROSS APPLY string_split(pai.topping, ',')),

/* Igual con los ingredientes excluidos de los pedidos */
pedidos_a_exclusiones AS (
	SELECT
		co.order_id,
		co.exclusions
	FROM temp_customer_orders co
		LEFT JOIN temp_runner_orders ro ON co.order_id = ro.order_id
	WHERE ro.cancellation ='' AND co.exclusions<>''),

lista_exclusiones AS (
	SELECT
		pae.order_id,
		TRIM (value) AS exclusions
	FROM pedidos_a_exclusiones pae
		CROSS APPLY string_split(pae.exclusions, ',')),

  /* Agrupamos para contar los ingredientes en las listas creadas anteriormente */

cuenta_exclusiones AS (
	SELECT
		le.exclusions,
		COUNT(le.exclusions) AS num_exclusions
	FROM lista_exclusiones le
	GROUP BY le.exclusions),

cuenta_ingredientes AS (
	SELECT
		li.topping,
		COUNT(li.topping) AS num_toppings
	FROM lista_ingredientes li
	GROUP BY li.topping)

/* Agrupamos y sumamos los ingredientes pedidos, los añadidos, y sustraemos los eliminados */
SELECT
	ROW_NUMBER() OVER(ORDER BY ci.num_toppings - COALESCE(ce.num_exclusions,0) DESC) AS puesto,
	ci.num_toppings - COALESCE(ce.num_exclusions,0) AS num_repeticiones,
	STRING_AGG(pt.topping_name, ', ') AS ingredientes
FROM SQL_EN_LLAMAS_ALUMNOS.case02.pizza_toppings pt
	LEFT JOIN cuenta_ingredientes ci ON pt.topping_id = ci.topping
	LEFT JOIN cuenta_exclusiones ce ON pt.topping_id = ce.exclusions
GROUP BY ci.num_toppings - COALESCE(ce.num_exclusions,0)
ORDER BY ci.num_toppings - COALESCE(ce.num_exclusions,0) DESC;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto.
CÓDIGO: Correcto. No obstante tengo 2 comentarios que darte:
	- Las ctes están muy bien, pero puede ser que puedas reducir el número de ctes, por ejemplo unir 'pedidos_a_ingredientes' y 'lista_ingredientes', 
	así puedes hacer más corto el código y más sostenible a largo plazo.

	- Intenta no usar mucho UNION ALL. Utiliza otros joins como INNER JOIN o LEFT JOIN para evitar el procesamiento de muchos datos. 
	Ejemplo de cómo se ha realizado la solución:
	----------------------------------------------
	CTE1 --> seleccionamos los pedidos que han sido recogidos (no son NULL en PICKUP_TIME)
	CTE2 --> extraemos los ingredientes de cada tipo de pizza, usando la función STRING_SPLIT para desglosar la lista de TOPPINGS
	CTE3 --> Calculamos el número total de ingredientes por nombre de topping, uniendo las CTE1 y la CTE2 y contando las apariciones de cada topping. 
	MEDIANTE INNER JOIN:
		CTE3 AS (
		SELECT C.TOPPING_NAME
			,COUNT(*) AS NUM_INGREDIENTES
		FROM CTE1 A
		INNER JOIN CTE2 B 
			ON A.PIZZA_ID = B.PIZZA_ID
		RIGHT JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS C 
			ON B.INGREDIENTE = C.TOPPING_ID
		GROUP BY C.TOPPING_NAME
		)
	CTE4 --> Procesamos los ingredientes excluidos de cada pizza, aplicando de nuevo STRING_SPLIT.
	CTE5 --> Contamos los ingredientes excluidos por nombre de topping --> Usamos INNER JOIN:
		CTE5 AS (
		SELECT B.TOPPING_NAME
			,COUNT(A.INGREDIENTE_EXCLUIDO) AS NUM_INGREDIENTES_EXCLUIDOS
		FROM CTE4 A
		INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS B 
			ON A.INGREDIENTE_EXCLUIDO = B.TOPPING_ID
		GROUP BY B.TOPPING_NAME
		)
	CTE6 --> Contamos el número de ingredientes adicionales especificados (como EXTRAS) --> Usamos INNER JOIN:
		CTE6 AS (
			SELECT B.TOPPING_NAME
				,COUNT(A.INGREDIENTE_INCLUIDO) AS NUM_INGREDIENTES_INCLUIDOS
			FROM CTE5 A
			INNER JOIN SQL_EN_LLAMAS.CASE02.PIZZA_TOPPINGS B 
				ON A.INGREDIENTE_INCLUIDO = B.TOPPING_ID
			GROUP BY B.TOPPING_NAME
			)
	CTE7 --> Contamos los ingredientes adicionales incluidos por nombre de topping.
	---------------------------------------------------------------------------------
	Como ves en esta query no se ha usado un UNION ALL sino un INNER JOIN.

 ----> Está muy bien vista la solución pero ya te digo, puede ser un coste muy grande usar el UNION ALL en algunos casos y es mejor usar otro tipo de JOIN :)

LEGIBILIDAD: Correcto. Me encanta que pongas comentarios y expliques qué vas haciendo en cada parte.

Muy bien, sigue asíiii!!!

*/
