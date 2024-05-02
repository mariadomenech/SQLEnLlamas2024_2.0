WITH ING_PIZZA_TOTAL AS (SELECT
	A.PIZZA_ID,
	LTRIM(VALUE) AS TOPPING,
	CANCELLATION,
	CASE WHEN CANCELLATION LIKE '%CANCELL%' THEN 1 ELSE 0 END AS CANCELADO
FROM CASE02.PIZZA_RECIPES A
CROSS APPLY STRING_SPLIT(TOPPINGS, ',')
LEFT OUTER JOIN CASE02.CUSTOMER_ORDERS B ON A.PIZZA_ID = B.PIZZA_ID
LEFT OUTER JOIN CASE02.RUNNER_ORDERS C ON B.ORDER_ID=C.ORDER_ID
WHERE CANCELLATION NOT LIKE '%CANCE%' OR CANCELLATION IS NULL),

ENVIOS_AUX AS (SELECT
	CASE WHEN EXTRAS = 'NULL' OR EXTRAS IS NULL THEN '' ELSE EXTRAS END AS EXTRAS,
	CASE WHEN EXCLUSIONS = 'NULL' OR EXCLUSIONS IS NULL THEN '' WHEN EXCLUSIONS = 'BEEF' THEN '3' ELSE EXCLUSIONS END AS EXCLUSIONS,
	CASE WHEN CANCELLATION LIKE '%CANCELL%' THEN 1 ELSE 0 END AS CANCELADO
FROM CASE02.CUSTOMER_ORDERS A
JOIN CASE02.RUNNER_ORDERS B ON A.ORDER_ID = B.ORDER_ID),

ING_PIZZA AS (SELECT 
	TOPPING AS TOPPING_ID,
	COUNT(A.TOPPING) AS CANTIDAD_PIZZA
FROM ING_PIZZA_TOTAL A
GROUP BY TOPPING),

ING_EXTRAS AS (SELECT
	EXTRAS AS TOPPING_ID,
	COUNT(EXTRAS) AS CANTIDAD_EXTRA
FROM (	SELECT
			LTRIM(VALUE) AS EXTRAS
		FROM ENVIOS_AUX
		CROSS APPLY STRING_SPLIT(EXTRAS, ',')
		WHERE CANCELADO = 0
		AND VALUE <>'') A
GROUP BY EXTRAS),

ING_EXCLUIDOS AS (SELECT
	EXCLUIDOS AS TOPPING_ID,
	COUNT(EXCLUIDOS) AS CANTIDAD_EXCLUIDA
FROM (	SELECT
			LTRIM(VALUE) AS EXCLUIDOS
		FROM ENVIOS_AUX
		CROSS APPLY STRING_SPLIT(EXCLUSIONS, ',')
		WHERE CANCELADO = 0
		AND VALUE <>'') A
GROUP BY EXCLUIDOS)

SELECT
	TOPPING_NAME,
	SUM(COALESCE(CANTIDAD_PIZZA,0) + COALESCE(CANTIDAD_EXTRA,0) - COALESCE(CANTIDAD_EXCLUIDA,0)) AS CANTIDAD_TOTAL
FROM CASE02.PIZZA_TOPPINGS A
LEFT OUTER JOIN ING_PIZZA PIZZA ON A.TOPPING_ID = PIZZA.TOPPING_ID
LEFT OUTER JOIN ING_EXTRAS EXTRA ON A.TOPPING_ID = EXTRA.TOPPING_ID
LEFT OUTER JOIN ING_EXCLUIDOS EXCL ON A.TOPPING_ID = EXCL.TOPPING_ID
GROUP BY TOPPING_NAME
ORDER BY CANTIDAD_TOTAL DESC;
