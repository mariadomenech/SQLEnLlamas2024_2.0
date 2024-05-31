--ALERTA! SE ENCONTRARON ERRORES AL ANALIZAR EL CODIGO SQL!
/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 4: Evolución del procedure para elegir el tipo de cálculo */



CREATE PROCEDURE SDF_CASO3_RETO4 @Cliente INT
	,@Mes VARCHAR(10) -- mes en formato yyyyMM
	,@Calculo INT --ESTABLECEMOS LOS SIGUIENTES VALORES: 1 BALANCE, 2 DEPOSITOS, 3 COMPRAS, 4 RETIROS
AS
BEGIN
	IF @Calculo = 1
	BEGIN
		WITH TRANSACCIONES_CLIENTE
		AS (
			SELECT SUM(CASE 
						WHEN txn_type = 'deposit'
							THEN txn_amount
						ELSE 0
						END) AS depositos
				,SUM(CASE 
						WHEN txn_type = 'purchase'
							THEN txn_amount
						ELSE 0
						END) AS compras
				,SUM(CASE 
						WHEN txn_type = 'withdrawal'
							THEN txn_amount
						ELSE 0
						END) AS retiros
			FROM CASE03.customer_transactions
			WHERE customer_id = @Cliente
				AND FORMAT(txn_date, 'yyyyMM') = @Mes
			)
		SELECT CONCAT (
				'El balance del cliente '
				,@Cliente
				,' para el mes de '
				,DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1))
				,' es de '
				,(
					SELECT ISNULL(depositos - compras - retiros, 0)
					FROM TRANSACCIONES_CLIENTE
					)
				,' Euros'
				) AS MENSAJE
	END
	ELSE IF @Calculo = 2
	BEGIN
		SELECT CONCAT (
				'La cantidad de depositos del cliente '
				,@Cliente
				,' para el mes de '
				,DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1))
				,' es de '
				,(
					SELECT ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'deposit'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes
					)
				,' Euros'
				) AS MENSAJE
	END
	ELSE IF @Calculo = 3
	BEGIN
		SELECT CONCAT (
				'La cantidad de compras del cliente '
				,@Cliente
				,' para el mes de '
				,DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1))
				,' es de '
				,(
					SELECT ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'purchase'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes
					)
				,' Euros'
				) AS MENSAJE
	END
	ELSE IF @Calculo = 4
	BEGIN
		SELECT CONCAT (
				'La cantidad de retiros del cliente '
				,@Cliente
				,' para el mes de '
				,DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1))
				,' es de '
				,(
					SELECT ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'withdrawal'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes
					)
				,' Euros'
				) AS MENSAJE
	END
	ELSE
	BEGIN
		SELECT ('No se ha introducido un valor de cálculo válido. Por favor introduzca un valor entre el 1 y el 4') AS MENSAJE
	END
END

-----------------------------------------------------------------
--EJECUCIONES DEL PROCEDURE
EXEC SDF_CASO3_RETO4 28
	,'202004'
	,1;

EXEC SDF_CASO3_RETO4 1
	,'202001'
	,2;
	
	
/*

COMENTARIO: Dado que queda poco tiempo, dejo sin hacer el control de errores. Creo que me llevaría un tiempo que tampoco aportaría mucho
valor a la solución de este reto puesto que sería añadir más de lo mismo (lógica de IF ELSE para controlar todas las casuísticas).
No obstante, si me queda tiempo lo actualizaré :)

/**/
