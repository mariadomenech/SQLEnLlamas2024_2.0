/*
En esta parte obtenemos los ingredientes extras que se generan en los pedidos que no están cancelados, ya que hay que tener en cuenta
estos ingredientes de cara a sumarlos a los ingredientes totales
*/
WITH ing_extras AS(
	SELECT 
		topping_id
		,topping_name
		,COUNT(extras) as veces_extras
	FROM (
		SELECT 
			CASE WHEN TRIM(value) IN ('null','') OR TRIM(value) IS NULL THEN 0 ELSE TRIM(value) END AS extras
		FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(extras, ',') 
		 WHERE order_id NOT IN (SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%')
		) consulta
	JOIN case02.pizza_toppings pt 
		ON consulta.extras=pt.topping_id 
	WHERE extras != 0 
	GROUP BY topping_id
		,topping_name
),

/*
En esta parte obtenemos los ingredientes excluidos que se generan en los pedidos que no están cancelados, ya que hay que tener en cuenta
estos ingredientes de cara a restarlos a los ingredientes totales
*/
ing_exclusions AS(
	SELECT 
		topping_id
		,topping_name
		,COUNT(exclusions) as veces_exclusions
	FROM (
		SELECT 
			CASE WHEN TRIM(value)='beef' THEN 3 WHEN TRIM(value) IN('null','') OR TRIM(value) IS NULL THEN 0 ELSE TRIM(value) END as exclusions
		FROM case02.customer_orders
		CROSS APPLY STRING_SPLIT(exclusions, ',') 
		 WHERE order_id NOT IN (SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%')
		) consulta
	JOIN case02.pizza_toppings pt 
		ON consulta.exclusions=pt.topping_id 
	WHERE exclusions != 0 
	GROUP BY topping_id
		,topping_name
),

/*
En esta parte obtenemos los ingredientes totales que se generan en los pedidos que se han realizado sin cancelación
*/
ing_pizzas_ok AS(
	SELECT
		pt.topping_id as topping_id
		,pt.topping_name as topping_name
		,count(*) as veces_ingredientes
	FROM(
		SELECT 
			co.order_id
			,co.pizza_id
			,TRIM(val1.value) AS toppings
		FROM case02.customer_orders co
		JOIN case02.pizza_recipes pr 
			ON co.pizza_id = pr.pizza_id
		CROSS APPLY STRING_SPLIT(toppings, ',') as val1
		WHERE co.order_id NOT IN (SELECT order_id FROM case02.runner_orders WHERE upper(cancellation) LIKE '%CANCELLATION%')
	) consulta
	JOIN case02.pizza_toppings pt 
		ON toppings = pt.topping_id
	GROUP BY pt.topping_id
		,pt.topping_name
),

/*
En esta parte sumamos a los ingredientes totales los extras y restamos las exclusiones, para así obtener el número
de ingredientes totales
*/
ing_total AS(
	SELECT 
		pt.topping_name
		,SUM(COALESCE(veces_ingredientes,0) + COALESCE(veces_extras, 0) - COALESCE(veces_exclusions,0)) AS num_ingredientes_gen
	FROM case02.pizza_toppings pt 
	LEFT JOIN ing_pizzas_ok	ipo 
		ON pt.topping_id = ipo.topping_id
	LEFT JOIN ing_extras iextras
		ON pt.topping_id = iextras.topping_id
	LEFT JOIN ing_exclusions iexclusions
		ON pt.topping_id = iexclusions.topping_id
	GROUP BY pt.topping_name
)

/*
En esta parte generamos el ranking y agrupamos los ingredientes que tienen el mismo número, para sacarlo de forma más limpia
*/
SELECT
	RANK() OVER (ORDER BY num_ingredientes_gen DESC) AS ranking
	,num_ingredientes_gen
	,STRING_AGG(topping_name, ', ') AS ingredientes
FROM ing_total
GROUP BY num_ingredientes_gen
order by ranking
;


/*COMENTARIOS JUANPE
TODO CORRECTO. PERO NO PERFECTO. EL RESULTADO MUY BIEN POR EL USO DEL STRING_AGG PARA AGRUPAR Y EL USO DEL CROSS APPLY PARA CONSEGUIR LOS INGREDIENTES. MUY BIEN LA ORDENACIÓN DEL CÓDIGO, ME GUSTA EL USO DE LOS WITH SOBRE TODO EN CASOS
COMO ESTOS DONDE SI NO IMPLICARIAN MUCHAS SUBCONSULTAS. MI PERO ESTÁ EN QUE HACES EL CAMBIO DE BEEF POR SU ID DE FORMA MANUAL CON UN CASE WHEN PERO PUEDE PLANTEARSE DE FORMA MÁS GENÉRICA HAY VARIAS FORMAS TE MUESTRO UNA:*/
ing_exclusions AS (
		SELECT TOPPING_ID
		     , TOPPING_NAME
		     , COUNT(EXCLUSIONS) AS VECES_EXCLUSIONS
		FROM (SELECT CASE WHEN TRIM(VALUE) IN('NULL','') OR TRIM(VALUE) IS NULL 
		                  THEN '0' 
		                  ELSE CAST(UPPER(TRIM(VALUE)) AS VARCHAR(50))
		                  END AS EXCLUSIONS
		       FROM CASE02.CUSTOMER_ORDERS
		       CROSS APPLY STRING_SPLIT(EXCLUSIONS, ',') 
		       WHERE ORDER_ID NOT IN (SELECT ORDER_ID FROM CASE02.RUNNER_ORDERS WHERE TRY_CAST(PICKUP_TIME AS DATE) IS NULL)
		    ) CONSULTA
		INNER JOIN CASE02.PIZZA_TOPPINGS PT 
		        ON CONSULTA.EXCLUSIONS =       TRIM(CAST(PT.TOPPING_ID   AS VARCHAR(50)))
		        OR CONSULTA.EXCLUSIONS = UPPER(TRIM(CAST(PT.TOPPING_NAME AS VARCHAR(50))))
		WHERE EXCLUSIONS != '0' 
		GROUP BY TOPPING_ID, TOPPING_NAME)
/*LA IDEA BASICAMENTE ES CRUZAR CON UNA CONDICIÓN OR O BIEN QUE NOS CRUCE EL ID O BIEN EL NAME AUNQUE SQL SERVER ES UN POCO "PUÑETERO" Y NOS OBLIGA A ANDAR CONVIRTIENDO TODO A CHAR PARA QUE FUNCIONE.

COMO EXTRA EN ESTE EJEMPLO TAMBIÉN HE APROVECHADO PARA MOSTRARTE UNA FORMA DE FILTRAR POR LOS CANCELADOS DISTINTA A LA QUE USAS CON EL LIKE Y BASICAMENTE ES QUE SI EL CAMPO PICKUP_TIME QUE ES LA FECHA DE ENTREGA
, QUE VIENE COMO CHAR, SI LO PODEMOS CONVERTIR EN FECHA ES QUE ESE PEDIDO SE ENTREGÓ Y SI NO SE PUEDE PORQUE SEA 'NULL' o 'null' o '' EL try_cast DEVUELVE null Y POR TANTO PODEMOS FILTRAR POR ESE CAMPO PORQUE INDICARÍA
QUE EL PEDIDO NO SE ENTREGO, ES DECIR, SE CANCELÓ, SI NO CONOCIAS EL TRY_CAST ES UNA VERSIÓN AVANZADA*/
