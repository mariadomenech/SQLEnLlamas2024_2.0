/* Alumno: Sergio Díaz */
/* CASO 3 - Ejercicio 5: Evolución del procedure para añadir funciones para realizar los caluculos*/

CREATE FUNCTION [dbo].[SDF_BALANCE] (@Cliente INT, @Mes VARCHAR(10)) --Función para el cálculo del balance. Le pasamos el cliente y el mes

RETURNS INT AS
BEGIN
	
DECLARE @Balance INT;

WITH TRANSACCIONES_CLIENTE AS 
(
SELECT
SUM(CASE WHEN txn_type = 'deposit' then txn_amount else 0 end) as depositos,
SUM(CASE WHEN txn_type = 'purchase' then txn_amount else 0 end) as compras,
SUM(CASE WHEN txn_type = 'withdrawal' then txn_amount else 0 end) as retiros
FROM CASE03.customer_transactions
WHERE customer_id = @Cliente and FORMAT(txn_date, 'yyyyMM') = @Mes
)

SELECT @Balance = ISNULL(depositos - compras - retiros, 0)
					FROM TRANSACCIONES_CLIENTE;

    RETURN @Balance

END;

CREATE FUNCTION [dbo].[SDF_TOTAL_DEPOSITADO] (@Cliente INT, @Mes VARCHAR(10)) --Función para el cálculo de los depositos. Le pasamos el cliente y el mes

RETURNS INT AS
BEGIN
	
DECLARE @Depositos INT;

SELECT @Depositos = ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'deposit'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes

    RETURN @Depositos

END;

CREATE FUNCTION [dbo].[SDF_TOTAL_COMPRAS] (@Cliente INT, @Mes VARCHAR(10))--Función para el cálculo de las compras. Le pasamos el cliente y el mes

RETURNS INT AS
BEGIN
	
DECLARE @Compras INT;

SELECT @Compras = ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'purchase'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes

    RETURN @Compras

END;

CREATE FUNCTION [dbo].[SDF_TOTAL_RETIROS] (@Cliente INT, @Mes VARCHAR(10)) --Función para el cálculo de los retiros. Le pasamos el cliente y el mes

RETURNS INT AS
BEGIN
	
DECLARE @Retiros INT;

SELECT @Retiros = ISNULL(SUM(txn_amount), 0)
					FROM CASE03.customer_transactions
					WHERE customer_id = @Cliente
						AND txn_type = 'withdrawal'
						AND FORMAT(txn_date, 'yyyyMM') = @Mes

    RETURN @Retiros

END;



CREATE PROCEDURE [dbo].[SDF_CASO3_RETO5] @Cliente INT --PROCEDIMIENTO PARA EL RETO 5
	,@Mes VARCHAR(10) -- Mes en formato yyyyMM
	,@Calculo INT --ESTABLECEMOS LOS SIGUIENTES VALORES: 1 BALANCE, 2 DEPOSITOS, 3 COMPRAS, 4 RETIROS
AS
BEGIN
	DECLARE @Resultado INT -- Declaramos las variables
	DECLARE @MesTexto VARCHAR(10)
	DECLARE @MensajeFinal VARCHAR(100)

	SET @MesTexto = DATENAME(month, DATEFROMPARTS(LEFT(@Mes, 4), RIGHT(@Mes, 2), 1)) -- Formateamos el mes para el mensaje de salida

	IF @Calculo = 1 --Comprobamos qué calculo es el que hay que calcular
	BEGIN
		SET @Resultado = dbo.SDF_BALANCE(@Cliente, @Mes) --Ejecutamos la función correspondiente

		SELECT @MensajeFinal = CONCAT ( --Creamos el mensaje de salida
				'El balance del cliente '
				,@Cliente
				,' para el mes de '
				,@MesTexto
				,' es de '
				,@Resultado
				,' Euros'
				)
	END
	ELSE IF @Calculo = 2
	BEGIN
		SET @Resultado = dbo.SDF_TOTAL_DEPOSITADO(@Cliente, @Mes)

		SELECT @MensajeFinal = CONCAT (
				'La cantidad de depositos del cliente '
				,@Cliente
				,' para el mes de '
				,@MesTexto
				,' es de '
				,@Resultado
				,' Euros'
				)
	END
	ELSE IF @Calculo = 3
	BEGIN
		SET @Resultado = dbo.SDF_TOTAL_COMPRAS(@Cliente, @Mes)

		SELECT @MensajeFinal = CONCAT (
				'La cantidad de compras del cliente '
				,@Cliente
				,' para el mes de '
				,@MesTexto
				,' es de '
				,@Resultado
				,' Euros'
				)
	END
	ELSE IF @Calculo = 4
	BEGIN
		SET @Resultado = dbo.SDF_TOTAL_RETIROS(@Cliente, @Mes)

		SELECT @MensajeFinal = CONCAT (
				'La cantidad de retiros del cliente '
				,@Cliente
				,' para el mes de '
				,@MesTexto
				,' es de '
				,@Resultado
				,' Euros'
				)
	END
	ELSE
	BEGIN
		SET @MensajeFinal = 'No se ha introducido un valor de cálculo válido. Por favor introduzca un valor entre el 1 y el 4' --Mensaje para el caso de que no sea un valor de cálculo válido
	END

	SELECT @MensajeFinal AS MENSAJE
END;

-----------------------------------------------------------------
--EJECUCIONES DEL PROCEDURE
EXEC SDF_CASO3_RETO5 125,'202001', 3

EXEC SDF_CASO3_RETO5 1,'202001', 1
	
	
/*

COMENTARIO: Al igual que para el ejercicio anterior, dado que queda poco tiempo, dejo sin hacer el control de errores.
Creo que me llevaría un tiempo que tampoco aportaría mucho valor a la solución de este reto puesto que sería añadir más 
de lo mismo (lógica de IF ELSE para controlar todas las casuísticas).
No obstante, si me queda tiempo lo actualizaré :)

/**/
