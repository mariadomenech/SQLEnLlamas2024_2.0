--Creamos una primera tabla temporal donde calculamos los ingresos por transacción
WITH ingresos AS (
SELECT distinct
	txn_id
	,SUM(qty*price) OVER (PARTITION BY txn_id) AS ingresos
FROM case04.sales
GROUP BY txn_id, qty, price
),

/* Después generamos otra tabla temporal donde creamos una variable tipo percentil para indicar si es continuo 
o discreto y, además, generamos los percentiles 25, 50 y 75 (tanto continuos como discretos) de los ingresos de 
la tabla anterior y los unimos para obtenerlos en una misma tabla
*/
continuo_discreto AS (
SELECT
	'CONTINUO' AS tipo_percentil
	,PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_25
	,PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_50
	,PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_75
FROM ingresos

UNION ALL

SELECT
	'DISCRETO' AS tipo_percentil
	,PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_25
	,PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_50
	,PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY ingresos) OVER () AS percentil_75
FROM ingresos
)

-- Por último, seleccionamos los percentiles de cada tipo percentil y los mostramos
SELECT DISTINCT
	tipo_percentil
	,percentil_25
	,percentil_50
	,percentil_75
FROM continuo_discreto
ORDER BY tipo_percentil ;
