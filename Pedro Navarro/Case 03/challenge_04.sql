-- RETO 4. EVOLUCIONA EL PROCEDIMIENTO DE AYER PARA QUE PODAMOS ELEGIR
-- EL TIPO DE CÁLCULO QUE NOS DEVUELVA POR MES Y CLIENTE:
--		- BALANCE: DEPÓSITO-COMPRA-RETIROS
--		- TOTAL DEPOSITADO
--		- TOTAL DE COMPRAS
--		- TOTAL DE RETIROS
-- Los mensajes están diseñados para que salgan en la ventana "Messages" con un PRINT
-- Si se quiere que los mensajes aparezcan en la ventana "Results", habría que cambiar los PRINT por SELECT
USE SQL_EN_LLAMAS_ALUMNOS;
GO

-- Creación del procedimiento almacenado
CREATE OR ALTER PROCEDURE case02.PNG_Ejercicio3_4_Procedimiento
	@customer_id INT
	,@year INT
	,@month_name VARCHAR(10)
	,@calculation_type VARCHAR(20)		-- Valores permitidos: 'depositos', 'compras', 'retiros', 'balance'
AS
BEGIN
	-- Cálculo de la cantidad total de compras
	DECLARE @output NUMERIC(20,2);

	IF @calculation_type IN ('depositos', 'balance')
		DECLARE @deposit NUMERIC(20,2);

		SELECT @deposit = SUM(CASE WHEN txn_type LIKE 'deposit' THEN txn_amount ELSE 0 END)
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
		WHERE customer_id = @customer_id
			AND YEAR(txn_date) = @year
			AND LOWER(DATENAME(month, txn_date)) LIKE LOWER(@month_name)
		GROUP BY
			customer_id
			,YEAR(txn_date)
			,DATENAME(month, txn_date);

	IF @calculation_type IN ('compras', 'balance')
		DECLARE @purchase NUMERIC(20,2);

		SELECT @purchase = SUM(CASE WHEN txn_type LIKE 'purchase' THEN txn_amount ELSE 0 END)
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
		WHERE customer_id = @customer_id
			AND YEAR(txn_date) = @year
			AND LOWER(DATENAME(month, txn_date)) LIKE LOWER(@month_name)
		GROUP BY
			customer_id
			,YEAR(txn_date)
			,DATENAME(month, txn_date);

	IF @calculation_type IN ('retiros', 'balance')
		DECLARE @withdrawal NUMERIC(20,2);

		SELECT @withdrawal = SUM(CASE WHEN txn_type LIKE 'withdrawal' THEN txn_amount ELSE 0 END)
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
		WHERE customer_id = @customer_id
			AND YEAR(txn_date) = @year
			AND LOWER(DATENAME(month, txn_date)) LIKE LOWER(@month_name)
		GROUP BY
			customer_id
			,YEAR(txn_date)
			,DATENAME(month, txn_date);
	
	IF @calculation_type = 'depositos'
		SET @output = @deposit
	ELSE IF @calculation_type = 'compras'
		SET @output = @purchase
	ELSE IF @calculation_type = 'retiros'
		SET @output = @withdrawal
	ELSE IF @calculation_type = 'balance'
		SET @output = @deposit - @purchase - @withdrawal

	-- Control de resultado nulo
	IF @output IS NULL
		DECLARE @customer_log INT;

		SELECT @customer_log = customer_id
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
		WHERE customer_id = @customer_id;

		-- Control y validación del parámetro @customer_id
		IF @customer_log IS NULL
			BEGIN
			DECLARE @min_customer_log INT, @max_customer_log INT;

			SELECT @min_customer_log = MIN(customer_id)
			FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions

			SELECT @max_customer_log = MAX(customer_id)
			FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions

			PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) +
					' NO HA REALIZADO NINGUNA OPERACIÓN. PRUEBE CON OTRO IDENTIFICADOR ENTRE ' + CAST(@min_customer_log AS VARCHAR(10)) + ' Y ' + CAST(@max_customer_log AS VARCHAR(10));
			END

		ELSE IF @customer_log IS NOT NULL
			DECLARE @year_log INT;

			SELECT @year_log = YEAR(txn_date)
			FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
			WHERE customer_id = @customer_id
				AND YEAR(txn_date) = @year;

			-- Control y validación del parámetro @year
			IF @customer_log IS NOT NULL AND @year_log IS NULL
				BEGIN
				DECLARE @all_years VARCHAR(500);

				WITH
					DISTINCT_YEARS AS (
						SELECT DISTINCT(YEAR(txn_date)) AS distinct_year
						FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
						WHERE customer_id = @customer_id
				)

				SELECT @all_years = STRING_AGG(distinct_year, ', ')
				FROM DISTINCT_YEARS;

				PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' NO HA REALIZADO NINGUNA OPERACIÓN EN EL AÑO ' +
						CAST(@year AS VARCHAR(4)) + '. PRUEBE CON ALGUNO DE ESTOS AÑOS: ' + @all_years;
				END

			ELSE IF @customer_log IS NOT NULL AND @year_log IS NOT NULL
				DECLARE @month_name_log VARCHAR(10);

				SELECT @month_name_log = DATENAME(month, txn_date)
				FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
				WHERE customer_id = @customer_id
					AND YEAR(txn_date) = @year
					AND LOWER(DATENAME(month, txn_date)) LIKE LOWER(@month_name);

				-- Control y validación del parámetro @month_name
				IF @customer_log IS NOT NULL AND @year_log IS NOT NULL AND @month_name_log IS NULL
					BEGIN
					DECLARE @all_month_names VARCHAR(200);
					WITH
					DISTINCT_MONTHS AS (
						SELECT DISTINCT(DATENAME(month, txn_date)) AS distinct_month
						FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
						WHERE customer_id = @customer_id
							AND YEAR(txn_date) = @year
					)

					SELECT @all_month_names = STRING_AGG(distinct_month, ', ')
					FROM DISTINCT_MONTHS;
						
					PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' NO HA REALIZADO NINGUNA OPERACIÓN EN EL MES DE ' +
							UPPER(@month_name) + ' DEL AÑO ' + CAST(@year AS VARCHAR(4)) + '. PRUEBE CON ALGUNO DE ESTOS MESES: ' + @all_month_names;
					END

	ELSE
		IF @calculation_type IN ('depositos', 'compras', 'retiros')
			PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' HA REALIZADO ' + UPPER(@calculation_type) +
					' VALORAD@S EN UN TOTAL DE ' + CAST(@output AS VARCHAR(23)) + ' EUR EN EL MES DE ' +
					UPPER(@month_name) + ' DEL AÑO ' + CAST(@year AS VARCHAR(4));

		IF @calculation_type = 'balance'
		PRINT 'EL BALANCE DEL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' EN EL MES DE ' +
				UPPER(@month_name) + ' DEL AÑO ' + CAST(@year AS VARCHAR(4)) + ' HA SIDO DE ' +
				CAST(@output AS VARCHAR(23)) + ' EUR';
END;
GO

-- Caso de uso - Modifica el valor de estas variables para comprobar distintas combinaciones
DECLARE @check_customer_id INT, @check_year INT, @check_month_name VARCHAR(10), @check_calculation_type VARCHAR(20);
SET @check_customer_id = 1
SET @check_year = 2020
SET @check_month_name = 'marzo'
SET @check_calculation_type = 'balance'

-- Ejecución del procedimiento almacenado
EXECUTE case02.PNG_Ejercicio3_4_Procedimiento
	@customer_id = @check_customer_id
	,@year = @check_year
	,@month_name = @check_month_name
	,@calculation_type = @check_calculation_type;
GO
-- Eliminación el procedimiento almacenado
DROP PROCEDURE case02.PNG_Ejercicio3_4_Procedimiento;
