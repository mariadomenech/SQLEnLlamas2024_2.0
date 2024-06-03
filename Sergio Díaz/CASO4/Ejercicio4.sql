/* Alumno: Sergio Díaz */
/* CASO 4 - Ejercicio 4: Valores 25, 50 y 75 de los valores de importes por transacción */


WITH INGRESOS -- CTE para calcular los ingresos de cada transaccion
AS (
	SELECT txn_id
		,SUM(qty * (price * (1 - discount * 0.01))) AS ingresos
	FROM case04.sales
	GROUP BY txn_id
	)
	
	
SELECT DISTINCT 'Percentiles continuos' AS TIPO_PERCENTIL -- Calculamos los percentiles continuos
	,PERCENTILE_CONT(0.25) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_25
	,PERCENTILE_CONT(0.50) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_50
	,PERCENTILE_CONT(0.75) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_75
FROM INGRESOS

UNION -- Unimos los resultados de ambas queries

SELECT DISTINCT 'Percentiles discretos' AS TIPO_PERCENTIL -- Calculamos los percentiles discretos
	,PERCENTILE_DISC(0.25) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_25
	,PERCENTILE_DISC(0.50) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_50
	,PERCENTILE_DISC(0.75) WITHIN
GROUP (
		ORDER BY ingresos
		) OVER () AS PERCENTIL_75
FROM INGRESOS;
