/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 3: Procedimiento para calcular el total de compras por cliente y mes */

CREATE PROCEDURE SDF_CASO3_RETO3 @Cliente INT
	,@Mes VARCHAR(10) --Parametros de entrada de nuestro procedimiento. El mes en formato yyyyMM
AS
SELECT CONCAT ( -- Mensaje a mostrar de nuestro procedimiento
		'El cliente '
		,@Cliente
		,' se ha gastado un total de '
		,compras
		,' EUR en compras de productos en el mes de '
		,DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1))
		) AS MENSAJE
FROM (
	SELECT ISNULL(SUM(txn_amount), 0) AS compras
	FROM case03.customer_transactions
	WHERE customer_id = @Cliente
		AND txn_type = 'purchase'
		AND FORMAT(txn_date, 'yyyyMM') = @Mes
	) COMPRAS;


EXEC SDF_CASO3_RETO3 @Cliente = 1
	,@Mes = '202003';-- Ejecutamos nuestro procedimiento para comprobar el funcionamiento
