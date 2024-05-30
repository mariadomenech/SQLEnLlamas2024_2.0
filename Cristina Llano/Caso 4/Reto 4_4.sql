/*¿Cuáles son los valores (importe) de los percentiles 25, 50 y 75 para los ingresos por transacción*/

WITH tabla_base_importes AS (
-- Calculamos el importe final de cada transacción
	SELECT SUM (price * qty) - SUM (price * qty * discount * 0.01) AS imp_final
	FROM 
	(	/* Existen muchos duplicados "puros" por lo que hacemos limpieza. Ejemplo: txn_id = '0102f5'*/
		SELECT DISTINCT *
		FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales
	) base
	GROUP BY txn_id
)
-- Se obtienen los distintos de cada flujo
SELECT DISTINCT
	  'Discreto' AS des_tipo_percentil
	  , PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_25
    , PERCENTILE_DISC (0.50) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_50
    , PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_75
FROM tabla_base_importes
UNION 
SELECT DISTINCT
	  'Continuo' AS des_tipo_percentil
	  , PERCENTILE_CONT (0.25) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_25
    , PERCENTILE_CONT (0.50) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_50
    , PERCENTILE_CONT (0.75) WITHIN GROUP (ORDER BY imp_final) OVER () AS por_percentil_75
FROM tabla_base_importes;
