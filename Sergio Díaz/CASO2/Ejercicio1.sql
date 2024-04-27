/* Alumno: Sergio Díaz */
/* CASO 2: Distancia acumulado y velocidad promedio de cada runner */

--Función para eliminar los caracteres que no son numéricos
CREATE FUNCTION [case02].[GetNumbers] (@Data VARCHAR(20)) 
RETURNS VARCHAR(20)
AS
BEGIN
	RETURN Left(SubString(@Data, PatIndex('%[0-9.-]%', @Data), 8000), PatIndex('%[^0-9.-]%', SubString(@Data, PatIndex('%[0-9.-]%', @Data), 8000) + 'X') - 1)
END;

--Select para solucionar el ejercicio
SELECT case02.runners.runner_id AS RUNNER_ID
	,COALESCE(ROUND([DISTANCIA_ACUMULADA_(KM)], 2), 0) AS 'DISTANCIA_ACUMULADA' --Formateo del número de salida
	,COALESCE(ROUND([KM/MINUTOS], 2), 0) AS 'VELOCIDAD_PROMEDIO_KM_H' --Formateo del número de salida
FROM case02.runners
LEFT JOIN ( --left join para mostrar todos los runners
	SELECT orders.runner_id AS RUNNER_ID
		,COALESCE(SUM(CAST([case02].GetNumbers(orders.distance) AS FLOAT)), 0) AS 'DISTANCIA_ACUMULADA_(KM)'
		,AVG(CAST([case02].GetNumbers(orders.distance) AS FLOAT) / NULLIF(CAST([case02].GetNumbers(orders.duration) AS FLOAT), 0) * 60) AS 'KM/MINUTOS' --Distancia acumulada partido de los minutos (Km/min) multiplicamos por 60 para pasarlo a Km/h
	FROM case02.runner_orders orders
	WHERE duration <> 'null' --Eliminamos del cálculo los pedidos cancelados
	GROUP BY orders.runner_id
	) AS calculo_dist_veloc  --Query que calcula la distancia acumulada y velocidad media de los trayectos
	ON runners.runner_id = calculo_dist_veloc.RUNNER_ID
