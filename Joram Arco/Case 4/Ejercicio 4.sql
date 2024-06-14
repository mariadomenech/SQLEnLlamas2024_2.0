/* Creamos una primera tabla temporal donde calculamos los ingresos brutos y descuento por transacción,
además tenemos en cuenta que se deben quitar los registros duplicados para evitar que el resultado nos salga mayor
debido a estos duplicados
P.D: Me costó darle un rato la lata a María para que me indicase al final esta parte de los duplicados y tenerlo
en cuenta para que no me bailasen los números :) */
WITH ingresos AS (
SELECT 
	txn_id
	,SUM(price * qty) AS ingresos_brutos
	,SUM(price * discount * 0.01 * qty) AS descuento
FROM (
	SELECT DISTINCT  *
	FROM case04.sales
) consulta
GROUP BY txn_id
),

/* Después generamos otra tabla temporal donde creamos una variable tipo percentil para indicar si es continuo 
o discreto y, además, generamos los percentiles 25, 50 y 75 (tanto continuos como discretos) de los ingresos brutos
menos los descuentos de la tabla anterior y los unimos para obtenerlos en una misma tabla */
continuo_discreto AS (
SELECT
	'CONTINUO' AS tipo_percentil
	,PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_25
	,PERCENTILE_CONT (0.5) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_50
	,PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_75
FROM ingresos
UNION
SELECT
	'DISCRETO' AS tipo_percentil
	,PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_25
	,PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_50
	,PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY ingresos_brutos-descuento) OVER () AS percentil_75
FROM ingresos
)

-- Por último, seleccionamos los percentiles de cada tipo percentil y los mostramos
SELECT DISTINCT
	tipo_percentil
	,percentil_25
	,percentil_50
	,percentil_75
FROM continuo_discreto;


/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

perfecto! Habiais trabajado antes con funciones de percentil?

Código: OK
Legibilidad: OK
Resultado: OK
*/
