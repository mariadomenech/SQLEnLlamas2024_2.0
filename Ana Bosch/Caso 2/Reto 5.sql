-- RETO 5: ¿Cuántas veces ha sido usado cada ingrediente sobre el total de pizzas entregadas? Ordena desde el más frecuente al menos frecuente.

WITH 
-- Eliminamos cualquier tipo de cancelación, al usar like en el caso en que este en mayusculas la palabra también la tendría en cuenta
CTE_RO
AS (
  SELECT order_id,
	CASE
		WHEN cancellation LIKE '%cancellation%' THEN 1
		ELSE 0
	END cancellation
  FROM case02.runner_orders
),

-- Separamos los extras en filas diferentes
CTE_CROSS_EXTRAS
AS (
	SELECT order_id
		,pizza_id
		,TRIM(value) as extras
	FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(extras, ',')
),	

-- Esta query lo que hace es asegurar que si hay escrito en minúscula o mayúscula algún ingrediente automaticamente busca su id para mostrarla
CTE_EXTRAS
AS (
	SELECT A.order_id
		,pizza_id
		,CASE	
			WHEN extras LIKE (
				SELECT topping_name 
				FROM case02.pizza_toppings PT 
				JOIN CTE_CROSS_EXTRAS CTE_EXTRAS
					ON PT.topping_name = CTE_EXTRAS.extras)
			THEN (
				SELECT topping_id 
				FROM case02.pizza_toppings PT 
				JOIN CTE_CROSS_EXTRAS CTE_EXTRAS
					ON PT.topping_name = CTE_EXTRAS.extras)
			WHEN ISNUMERIC(extras) = 1 THEN extras
			ELSE 0
		END AS extras
	FROM CTE_CROSS_EXTRAS A
	JOIN CTE_RO B 
		ON A.order_id = B.order_id
	WHERE cancellation != 1
),

-- Separamos las exclusiones en filas diferentes
CTE_CROSS_EXCLUIONS
AS (
	SELECT order_id
		,pizza_id
		,TRIM(value) as exclusions
	FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(exclusions, ',')
),

-- Esta query lo que hace es asegurar que si hay escrito en minúscula o mayúscula algún ingrediente automaticamente busca su id para mostrarla
CTE_EXCLUSION
AS (
	SELECT A.order_id
		,pizza_id
		,CASE	
			WHEN exclusions LIKE (
				SELECT topping_name 
				FROM case02.pizza_toppings PT 
				JOIN CTE_CROSS_EXCLUIONS CTE_EXCLUIONS
					ON PT.topping_name = CTE_EXCLUIONS.exclusions)
			THEN (
				SELECT topping_id 
				FROM case02.pizza_toppings PT 
				JOIN CTE_CROSS_EXCLUIONS CTE_EXCLUIONS
					ON PT.topping_name = CTE_EXCLUIONS.exclusions)
			WHEN ISNUMERIC(exclusions) = 1 THEN exclusions
			ELSE 0
		END AS exclusions
	FROM CTE_CROSS_EXCLUIONS A
	JOIN CTE_RO B 
		ON A.order_id = B.order_id
	WHERE cancellation != 1
),

--Contamos las exclusiones por ingrediente
CTE_RESTA_EXCLUSION
AS (

	SELECT topping_id
		,COUNT(*) AS exclusiones_restar
	FROM CTE_EXCLUSION A
	JOIN case02.pizza_toppings B
	ON A.exclusions = B.topping_id
	GROUP BY topping_id
),

--Contamos los extras por ingrediente
CTE_SUMA_EXTRA
AS (
	SELECT topping_id
		,COUNT(*) AS extras_sumar
	FROM CTE_EXTRAS A
	JOIN case02.pizza_toppings B
	ON A.extras = B.topping_id
	GROUP BY topping_id
),

--Pivotamos los topping
CTE_PIVOTADA
AS (
	SELECT pizza_id
		,topping_id
	FROM (
		SELECT * 
		FROM case02.pizza_recipes_split
	) AS pizzas_recipes_split  
	UNPIVOT (
		topping_id FOR toppings IN (
			topping_1, 
			topping_2, 
			topping_3, 
			topping_4, 
			topping_5,
			topping_6, 
			topping_7, 
			topping_8
		)  
	) AS tabla_pivotada
),

--Contamos los pedidos que se realizan
CTE_PEDIDOS
AS (
	SELECT CO.pizza_id
		,COUNT(*) as pedidos
	FROM CTE_RO CTE_RO
	JOIN case02.customer_orders CO
		ON CTE_RO.order_id = CO.order_id
	WHERE cancellation != 1
	GROUP BY pizza_id

),

-- Calculamos las repeticiones de ingredientes a través de las pizzas en las que están
CTE_SUMA_PEDIDOS
AS (

	SELECT topping_id
		,sum(pedidos) AS repeticiones
	FROM CTE_PEDIDOS A
	JOIN CTE_PIVOTADA B
		ON A.pizza_id = B.pizza_id
	GROUP BY topping_id
),

-- Calculo final de Ingredientes pizzas - exclusiones + extras
CTE_SUMA_TOTAL
AS (
	SELECT A.topping_id
		,COALESCE(COALESCE(repeticiones + extras_sumar, repeticiones) - exclusiones_restar, COALESCE(repeticiones + extras_sumar, repeticiones)) as repeticiones
	FROM CTE_SUMA_PEDIDOS A
	LEFT JOIN CTE_SUMA_EXTRA B
		ON A.topping_id = B.topping_id
	LEFT JOIN CTE_RESTA_EXCLUSION D
		ON A.topping_id = D.topping_id
)


-- Query para sacar el resultado en el formato establecido
SELECT RANK () OVER(ORDER BY repeticiones DESC) ranking
	,repeticiones
	,STRING_AGG(topping_name, ', ') AS topping
FROM CTE_SUMA_TOTAL A
JOIN case02.pizza_toppings B
	on A.topping_id = B.topping_id
GROUP BY repeticiones

-- Puede parecer un codigo complejo, no obstante la idea de encapsular operaciones especificas que puedan reutilizarse en calculos más complejos me parece mejor opción.
-- En una de las CTE se calcula en función de cualquier ingrediente que se escriba el id correspondiente, para intentar 'automatizar' el proceso.


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Enhorabuena! Es un ejercicio de 10. Limpio, legible y todo lo genérico que se puede hacer con las limitaciones de que UNPIVOT no te permita tablas dinámicas. 
No creo que sea un código complejo, tiene muchas lineas pero, como ya hablamos hace unos retos, creo que la idea de que cada CTE haga su proceso es la mejor manera de hacerlo legible. 
Y en este caso, que es uno de los ejercicios más complejos, no he tenido ningún problema para entender lo que hacía cada parte del código.
Hay punto extra por la solución que das en CTE_EXTRAS y CTE_EXCLUSION. ;)

Mucho ánimo con el siguiente, que fue mi némesis en la primera edición!

*/
