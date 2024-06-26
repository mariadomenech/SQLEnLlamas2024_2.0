CREATE OR ALTER PROCEDURE AMR_EJERCICIO_3_4_PROCEDURE

	@CUSTOMER_ID INTEGER,
	@MES INTEGER,
	@TIPO_TXN INTEGER

AS

BEGIN
	DECLARE @TEXTO VARCHAR(100)
	DECLARE @DEPOSITO AS DECIMAL (10,2)
	DECLARE @COMPRA AS DECIMAL (10,2)
	DECLARE @RETIRO AS DECIMAL (10,2)

--VER SI EXISTE EL CLIENTE
IF EXISTS 
		(SELECT CUSTOMER_ID 
		FROM CASE03.CUSTOMER_TRANSACTIONS 
		WHERE CUSTOMER_ID = @CUSTOMER_ID)
--SI EXISTE EL CLIENTE, VER SI NO EXISTE MES
	IF @MES < 1 OR @MES > 12 
--SI NO EXISTE EL MES SE GUARDA EL SIGUIENTE TEXTO
		SET @TEXTO = 'Elige un valor de mes valido (entre 1 y 12)' 
	ELSE
--SI EXISTE EL MES Y EL CLIENTE
		BEGIN
		SELECT 
			@DEPOSITO = COALESCE(SUM(CASE WHEN TXN_TYPE = 'DEPOSIT' THEN TXN_AMOUNT ELSE 0 END),0),
			@COMPRA = COALESCE(SUM(CASE WHEN TXN_TYPE = 'PURCHASE' THEN TXN_AMOUNT ELSE 0 END),0),
			@RETIRO = COALESCE(SUM(CASE WHEN TXN_TYPE = 'WITHDRAWAL' THEN TXN_AMOUNT ELSE 0 END),0)
		FROM CASE03.CUSTOMER_TRANSACTIONS
		WHERE CUSTOMER_ID = @CUSTOMER_ID
			AND MONTH(TXN_DATE) = @MES 
--SE COMPRUEBA QUE VALOR SE HA METIDO DE TRANSACCIÓN
		IF @TIPO_TXN = 1
			SET @TEXTO = CONCAT('El cliente ',@CUSTOMER_ID,' tiene un balance total de ',(@DEPOSITO - @COMPRA - @RETIRO),'€ en el mes de ',LOWER(DATENAME(MONTH,DATEFROMPARTS(2024,@MES,1))),'.')
		ELSE IF @TIPO_TXN = 2
			SET @TEXTO = CONCAT('El cliente ',@CUSTOMER_ID,' ha depositado un total de ',@DEPOSITO,'€ en el banco en el mes de ',LOWER(DATENAME(MONTH,DATEFROMPARTS(2024,@MES,1))),'.')
		ELSE IF @TIPO_TXN = 3
			SET @TEXTO = CONCAT('El cliente ',@CUSTOMER_ID,' se ha gastado un total de ',@COMPRA,'€ en compras de productos en el mes de ',LOWER(DATENAME(MONTH,DATEFROMPARTS(2024,@MES,1))),'.')
		ELSE IF @TIPO_TXN = 4
			SET @TEXTO = CONCAT('El cliente ',@CUSTOMER_ID,' ha retirado un total de ',@RETIRO,'€ del banco durante el mes de ',LOWER(DATENAME(MONTH,DATEFROMPARTS(2024,@MES,1))),'.')
		ELSE SET @TEXTO = 'Introduce un valor de tipo transacción correcto (1 = balance, 2 = deposito, 3 = compra y 4 = retiro)'
		END
ELSE
--SI NO EXISTE EL CLIENTE SE GUARDA EL SIGUIENTE TEXTO
SET @TEXTO = CONCAT('No existe el cliente ',@CUSTOMER_ID) 
--POR ULTIMO, SE EJECUTA EL TEXTO GUARDADO
SELECT @TEXTO AS RESULTADO
END;

--PRUEBAS DEL PROCEDURE
EXECUTE AMR_EJERCICIO_3_4_PROCEDURE 1,3,1;
EXECUTE AMR_EJERCICIO_3_4_PROCEDURE 1,3,4;
EXECUTE AMR_EJERCICIO_3_4_PROCEDURE 1,3,2;
EXECUTE AMR_EJERCICIO_3_4_PROCEDURE 1,3,3;

--SE ELIMINA EL PROCEDURE
DROP PROCEDURE IF EXISTS AMR_EJERCICIO_3_4_PROCEDURE;





/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Enhorabuena!!

Código: OK, controlas todas casuísticas
Legibilidad: OK, me ha faltado que me pongas al inicio del procedure qué código representa cada tipo de transacción
Resultado: Muy completo!

*/
