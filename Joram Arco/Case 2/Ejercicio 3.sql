/*
Aquí realizamos la limpieza de la tabla customer_orders, para este ejercicio solo es necesario (y puede ser en otro paso)
calcular el precio de las pizzas teniendo en cuenta que la pizza con id 1 (meat lovers) cuesta 12€ y la pizza con id (vegetariana)
cuesta 10€
*/
WITH customer_orders_cleaned AS(
	SELECT 
		COALESCE(order_id, 0) AS order_id
		,pizza_id
		,CASE WHEN pizza_id = 1 THEN 12
			  WHEN pizza_id = 2 THEN 10
			  ELSE 0 
		 END AS precio_pizza
	FROM case02.customer_orders
),

/*
Aquí realizamos la limpieza de la tabla runner_orders, para este ejercicio necesitamos sacar por un lado los pedidos completados
(aquellos que no han sido cancelados) y por otro lado limpiamos también la distancia para quedarnos solo con el número sin los
caracteres
*/
runner_orders_cleaned AS (
	SELECT 
		COALESCE(runner_orders.order_id, 0) AS order_id
		,CASE WHEN UPPER(cancellation) LIKE '%CANCELLATION%' THEN 0 ELSE 1 END AS pedidos_completados
		,COALESCE(CAST(REPLACE(distance, 'km', '') AS FLOAT), 0) AS distancia
	FROM case02.runner_orders 
),

/*
Aquí realizamos el cálculo de los precios de los ingredientes extras por pedido, en este caso como es 1€ por cada ingrediente extra,
obtendremos 1 por el número de ingredientes extra que se encuentren en los pedidos, y con la función cross apply separamos en filas
individuales los valores de extras que vienen agrupados
*/
price_extras_calculated AS (
	SELECT 
		order_id
		,SUM(extras) * 1 as precio_extras
	FROM(
		SELECT 
			order_id
			,CASE WHEN COALESCE(value, '') IN ('', 'null') THEN 0 ELSE 1 END AS extras
		FROM case02.customer_orders 
		CROSS APPLY STRING_SPLIT(extras, ',') --utilizamos esta función para separar los extras de cada pizza y obtener una fila individual
	) consulta
	GROUP BY order_id
)

/*
Aquí obtenemos finalmente el precio ingresado por las pizzas, el precio ingresado por los ingredientes extras y los costes de pagar a los runners
en función de los km que han recorrido. Además, como paso final, calculamos los beneficios totales que obtendría Guiseppe teniendo en cuenta las pizzas
vendidas y restando lo que se ha pagado a los runners
*/
SELECT 
	SUM(precio_pizza) AS ing_pizzas
	,SUM(precio_extras) AS ing_ingredientes_extras
	,SUM(precio_distancia) AS costes
	,sum(precio_pizza) + sum(precio_extras)- sum(precio_distancia) as beneficios --aquí se calcularían los beneficios que obtiene Giuseppe después de las entregas
FROM(
	SELECT  
		precio_extras
		,distancia * 0.3 as precio_distancia
		,sum(precio_pizza) AS precio_pizza
	FROM runner_orders_cleaned roc
	JOIN customer_orders_cleaned coc
		ON roc.order_id = coc.order_id
	JOIN price_extras_calculated pec
		ON coc.order_id = pec.order_id
	WHERE pedidos_completados = 1 --quitamos los pendidos cancelados ya que no contabilizan para el total
	GROUP BY precio_extras
		,distancia
		,coc.order_id
) consulta2
;
/*COMENTARIOS JUANPE:
Genial por incluir beneficios que era realmente lo que se pedia aunque por error la app no lo mostroba. 
Bien visto la función STRING_SPLIT
Gracias por los comentarios nos ayudan bastante a los que estamos corrigiendo.
¡Todo perfecto!*/
