--CASO 4: Ejercicio 4
--Creamos una subconsulta con el cálculo del total de ingresos por transacción
WITH operations AS (
	SELECT  txn_id,
			SUM((qty * price) * (1 - discount * 0.01)) AS earnings
	FROM (
        --Eliminamos los duplicados que ya encontramos en ejercicios anteriores
		SELECT DISTINCT *
		FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales]
            ) no_duplicates
	GROUP BY txn_id
)

--Calculamos los percentiles de los ingresos por transacción tanto de forma continua como discreta.
SELECT TOP 1 'CONTINUOUS' AS type_pct,
			 PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_25,
			 PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_50,
			 PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_75
FROM operations

UNION ALL

SELECT TOP 1 'DISCRETE' AS type_pct,   
			 PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_25,
			 PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_50,
			 PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY earnings) OVER () AS percentil_75 
FROM operations
;
