/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 4: Evolución del procedure para elegir el tipo de cálculo */


CREATE PROCEDURE [dbo].[SDF_CASO3_RETO4] @Cliente INT
	,@Mes VARCHAR(10)
	,@Calculo INT --Parametros de entrada de nuestro procedimiento. El mes en formato yyyyMM
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
			IF @Calculo = 1 -- Calculamos el balance para el cliente y mes introducidos
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
			ELSE IF @Calculo = 2 -- Calculamos los depositos para el cliente y mes introducidos
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
			ELSE IF @Calculo = 3 -- Calculamos las compras para el cliente y mes introducidos
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
			ELSE IF @Calculo = 4 -- Calculamos los retiros para el cliente y mes introducidos
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
				SELECT ('No se ha introducido un valor de cálculo válido. Por favor introduzca un valor entre el 1 y el 4') AS MENSAJE -- Mensaje a mostrar si el valor del cálculo no es válido
			END
		END
		ELSE
		BEGIN
			SELECT CONCAT (
					-- Mensaje a mostrar si no existe el mes introducido o no es correcto
					'El mes '
					,@Mes
					,' no existe en la tabla o bien no es correcto (formato YYYYMM)'
					) AS MENSAJE
		END
	END
	ELSE
	BEGIN
		SELECT CONCAT (
				-- Mensaje a mostrar si no existe el cliente en el origen de datos
				'El cliente '
				,@Cliente
				,' no existe'
				) AS MENSAJE
	END
END;

---------Ejecuciones del procedure-------------
EXEC SDF_CASO3_RETO4 308,'202003',2

EXEC SDF_CASO3_RETO4 308,'202103',2

EXEC SDF_CASO3_RETO4 906,'202003',1

EXEC SDF_CASO3_RETO4 315,'202004',7
