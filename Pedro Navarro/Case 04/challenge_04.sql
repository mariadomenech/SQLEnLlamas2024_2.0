-- RETO 4. ¿CUÁLES SON LOS VALORES (IMPORTE) DE LOS PERCENTILES 25, 50 Y 75
-- PARA LOS INGRESOS POR TRANSACCIÓN?
WITH
	DEDUPLICATED_DATA AS (
		SELECT DISTINCT *
		FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales
	)

	,TOTAL_REVENUE AS (
		SELECT
			txn_id
			,SUM(qty*price*(1-discount/100.0)) AS total_revenue
		FROM DEDUPLICATED_DATA
		GROUP BY txn_id
	)

	,PERCENTILE_CONT AS (
		SELECT DISTINCT
			'CONTINUO' AS percentile_type
			,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_25
			,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_50
			,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_75
		FROM TOTAL_REVENUE
	)

	,PERCENTILE_DISC AS (
		SELECT DISTINCT
			'DISCRETO' AS percentile_type
			,PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_25
			,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_50
			,PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY total_revenue) OVER () AS percentile_75
		FROM TOTAL_REVENUE
	)

	,PERCENTILES AS (
		SELECT *
		FROM PERCENTILE_CONT
		UNION ALL
		SELECT *
		FROM PERCENTILE_DISC
	)

SELECT *
FROM PERCENTILES;




/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

RESULTADO: Correcto
CÓDIGO: Correcto.
LEGIBILIDAD: Correcto.

*/
