-- RETO 4: Cuáles son los valores (importe) de los percentiles 25, 50 y 75 para los ingresos por transacción.

-- Tabla temporal para obtener el precio final de cada transacción, teniendo en cuenta el descuento y cantidad
WITH CTE_PRECIO_TRANSACCION
AS (
	SELECT txn_id
		,SUM(qty * (price - (price * discount * 0.01))) AS preciofinal
	FROM (
		SELECT DISTINCT * 
		FROM case04.sales
	) A
	GROUP BY txn_id
)

-- Se une el calculo de los percentiles continuos con los percentiles discontinuos y se ordena por tipo percentil ascendentemente
SELECT DISTINCT 
	'CONTINUO' AS tipo_percentil
	,PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_25
	,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_50
	,PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_75
FROM CTE_PRECIO_TRANSACCION

UNION

SELECT DISTINCT 
	'DISCONTINUO' AS tipo_percentil
	,PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_25
	,PERCENTILE_DISC(0.5) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_50
	,PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY preciofinal) OVER () AS pc_75
FROM CTE_PRECIO_TRANSACCION

ORDER BY 1 ASC

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto! :)

*/
