-- RETO 3. CREA UN PROCEDIMIENTO ALMACENADO QUE AL INTRODUCIR EL IDENTIFICADOR DEL CLIENTE Y EL MES,
-- CALCULE EL TOTAL DE COMPRAS (PURCHASE) Y QUE TE DEVUELVA EL SIGUIENTE MENSAJE:
-- "EL CLIENTE 1 SE HA GASTADO UN TOTAL DE 1276 EUR EN COMPRAS DE PRODUCTOS EN EL MES DE MARZO"
USE SQL_EN_LLAMAS_ALUMNOS;
GO

-- Creación del procedimiento almacenado
CREATE OR ALTER PROCEDURE case02.PNG_Ejercicio3_3_Procedimiento
	@customer_id INT
	,@year INT
	,@month_name VARCHAR(10)
AS
BEGIN
	-- Cálculo del gasto total de compras
	DECLARE @total_purchase NUMERIC(20,2);

	SELECT @total_purchase = SUM(CASE WHEN txn_type LIKE 'purchase' THEN txn_amount ELSE 0 END)
	FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
	WHERE customer_id = @customer_id
		AND YEAR(txn_date) = @year
		AND LOWER(DATENAME(month, txn_date)) LIKE LOWER(@month_name)
	GROUP BY
		customer_id
		,YEAR(txn_date)
		,DATENAME(month, txn_date);

	-- Control de resultado nulo
	IF @total_purchase IS NULL
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
					' NO HA REALIZADO NINGUNA COMPRA. PRUEBE CON OTRO IDENTIFICADOR ENTRE ' + CAST(@min_customer_log AS VARCHAR(10)) + ' Y ' + CAST(@max_customer_log AS VARCHAR(10));
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

				PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' NO HA REALIZADO NINGUNA COMPRA EN EL AÑO ' +
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
						
					PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' NO HA REALIZADO NINGUNA COMPRA EN EL MES DE ' +
							UPPER(@month_name) + ' DEL AÑO ' + CAST(@year AS VARCHAR(4)) + '. PRUEBE CON ALGUNO DE ESTOS MESES: ' + @all_month_names;
					END

	ELSE
		PRINT 'EL CLIENTE ' + CAST(@customer_id AS VARCHAR(10)) + ' SE HA GASTADO UN TOTAL DE ' +
				CAST(@total_purchase AS VARCHAR(23)) + ' EUR EN COMPRAS DE PRODUCTOS EN EL MES DE ' +
				UPPER(@month_name) + ' DEL AÑO ' + CAST(@year AS VARCHAR(4));
END;
GO

-- Caso de uso - Modifica el valor de estas variables para comprobar distintas combinaciones
DECLARE @check_customer_id INT, @check_year INT, @check_month_name VARCHAR(10);
SET @check_customer_id = 1
SET @check_year = 2020
SET @check_month_name = 'marzo'

-- Ejecución del procedimiento almacenado
EXECUTE case02.PNG_Ejercicio3_3_Procedimiento @customer_id = @check_customer_id, @year = @check_year, @month_name = @check_month_name;
GO
-- Eliminación el procedimiento almacenado
DROP PROCEDURE case02.PNG_Ejercicio3_3_Procedimiento;
