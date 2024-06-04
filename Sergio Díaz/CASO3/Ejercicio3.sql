/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 3: Procedimiento para calcular el total de compras por cliente y mes */

CREATE PROCEDURE [dbo].[SDF_CASO3_RETO3] @Cliente INT
	,@Mes VARCHAR(10) -- Parametros de entrada del procedimiento (mes en formato YYYYMM)
AS
BEGIN
	IF (
			--Chequeamos si existe el cliente		
			EXISTS (
				SELECT DISTINCT customer_id
				FROM case03.customer_transactions
				WHERE customer_id = @Cliente
				)
			)
	BEGIN
		IF (
				--Chequeamos si existe el mes		
				EXISTS (
					SELECT DISTINCT *
					FROM case03.customer_transactions
					WHERE FORMAT(txn_date, 'yyyyMM') = @Mes
					)
				)
		BEGIN
			SELECT CONCAT ( -- Si existe calculamos la cantidad gastada para el mes introducido
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
		END
		ELSE
		BEGIN
			SELECT CONCAT ( -- Mensaje a mostrar si no existe el mes introducido o no es correcto
					'El mes '
					,@Mes
					,' no existe en la tabla o bien no es correcto (formato YYYYMM)'
					) AS MENSAJE
		END
	END
	ELSE
	BEGIN
		SELECT CONCAT ( -- Mensaje a mostrar si no existe el cliente en el origen de datos
				'El cliente '
				,@Cliente
				,' no existe'
				) AS MENSAJE
	END
END


----------Ejecuciones del procedimiento--------------
EXEC SDF_CASO3_RETO3 306, '202003'
EXEC SDF_CASO3_RETO3 306, '202103'
EXEC SDF_CASO3_RETO3 308, '202001'
EXEC SDF_CASO3_RETO3 951, '202002'
