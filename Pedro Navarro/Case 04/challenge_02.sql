-- RETO 2. ¿CUÁL ES LA COMBINACIÓN DE PRODUCTOS DISTINTOS MÁS REPETIDA EN UNA
-- SOLA TRANSACCIÓN? LA COMBINACIÓN DEBE SER DE AL MENOS 3 PRODUCTOS DISTINTOS
DECLARE @MIN_PRODUCT_COMBINATION INT = 3;

WITH
	-- Se seleccionan los identificadores de transacción que contienen al menos 3 productos
	TRANSACTION_ITEMS_SELECTION AS (
		SELECT txn_id
		FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales
		GROUP BY txn_id
		HAVING COUNT(*) >= @MIN_PRODUCT_COMBINATION
	)

	-- Primero, se hace un SELECT DISTINCT para descartar líneas de transacción repetidas
	-- Luego habría que ordenar los productos en cada transacción para que las combinaciones de productos sean únicas
	-- SQL Server no te permite usar la cláusula ORDER BY en una CTE. ROW_NUMBER() simularía dicha cláusula
	,ORDERED_SALES AS (
		SELECT DISTINCT
			sal.txn_id
			,pd.product_name
			,ROW_NUMBER() OVER (PARTITION BY sal.txn_id ORDER BY sal.txn_id, pd.product_name) AS rn
		FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales AS sal
		-- Se filtran las transacciones que cumplen la condición del enunciado
		INNER JOIN TRANSACTION_ITEMS_SELECTION AS tic
			ON sal.txn_id = tic.txn_id
		-- Se seleccionan los nombres de los productos
		LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details AS pd
			ON sal.prod_id = pd.product_id
	)

	-- Se concatenan los productos en cada transacción para generar un identificador para cada combinación de productos
	,PRODUCT_COMBINATIONS AS (
		SELECT
			txn_id
			,STRING_AGG(product_name, ' | ') AS prod_combination
		FROM ORDERED_SALES
		GROUP BY txn_id
	)

	-- Se cuenta el número de veces que aparece cada combinación de productos en las transacciones
	,PRODUCT_COMBINATION_COUNT AS (
		SELECT
			COUNT(*) AS txn_count
			,prod_combination
		FROM PRODUCT_COMBINATIONS
		GROUP BY prod_combination
	)

	-- Se hace un ranking de las combinaciones de productos más repetidas
	,PRODUCT_COMBINATION_DENSE_RANK AS (
		SELECT
			txn_count
			,DENSE_RANK() OVER (ORDER BY txn_count DESC) AS dr
			,prod_combination
		FROM PRODUCT_COMBINATION_COUNT
	)

	-- Se filtra la combinación más repetida
	,MOST_REPEATED_PRODUCT_COMBINATION AS (
		SELECT
			txn_count
			,prod_combination
		FROM PRODUCT_COMBINATION_DENSE_RANK
		WHERE dr = 1
	)

SELECT *
FROM MOST_REPEATED_PRODUCT_COMBINATION;
