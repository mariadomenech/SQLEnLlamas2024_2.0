/*Una pizza meatlovers cuesta 12€ y una vegetariana 10€, y cada ingrediente extra supone 1€ adicional.
Por otro lado, a cada corredor se le paga a 0.30€/km recorrido.
¿Cuándo dinero le sobra a Guiseppe después de estas entregas*/

-- Primero eliminamos la tabla temporal por si hemos estado haciendo pruebas previamente
-- Si no existe dará error, pero no pasa nada, es correcto, también se elimina a cerrar sesión.
DROP TABLE #base_coste_pedido

-- Se obtiene el coste del pedido del cliente.
SELECT ingreso.order_id
  , imp_pizza_base + num_ingredientes_extras AS imp_coste_pedido
INTO #base_coste_pedido
FROM 
(	-- Coste pizzas sin extras de cada perdido.
	SELECT ord.order_id
    , SUM (CASE WHEN pizza_id = 1 THEN 12 ELSE 10 END) AS imp_pizza_base
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders ord
	GROUP BY ord.order_id
)ingreso
INNER JOIN 
(	-- Se obtienen los extras de cada pedido
	SELECT order_id
    , SUM(CASE WHEN VALUE = 0 THEN 0 ELSE 1 END) AS num_ingredientes_extras
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.customer_orders
  CROSS APPLY STRING_SPLIT ((CASE WHEN (extras is null OR extras = 'null' or extras = '') 
									THEN '0' ELSE extras END ), ',')
	GROUP BY order_id
) ingredi
ON ingreso.order_id = ingredi.order_id

SELECT SUM (pedidos.imp_coste_pedido) AS imp_ingresos_pedidos
  , SUM (pedidos.imp_coste_pedido - imp_coste_distance) AS imp_beneficios_Guiseppe
  , SUM (imp_coste_distance) AS imp_costes_reparto
FROM #base_coste_pedido pedidos
INNER JOIN 
(	SELECT order_id
		, (CAST (CASE WHEN (distance is null OR distance = 'null') THEN '0'
					        ELSE REPLACE(distance, 'km','') END
				     AS DECIMAL(3,1)))*0.3 AS imp_coste_distance
	FROM SQL_EN_LLAMAS_ALUMNOS.case02.runner_orders
	-- Valor 0 si el pedido no está cancelado, valor 1 si está cancelado. Y filtramos por los no cancelados
	WHERE (CASE	WHEN (cancellation is null OR cancellation = 'null' OR cancellation = '') THEN 0 ELSE 1 END) = 0
) run
  ON run.order_id = pedidos.order_id
;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Impecable Cristina, enhorabuena!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Me ha gustado que muestres los beneficios directamente porque al final es lo que más le interesa a Guiseppe!


*/
