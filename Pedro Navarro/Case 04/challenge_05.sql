-- RETO 5. CREA UNA FUNCIÓN QUE, INTRODUCIÉNDOLE UNA CATEGORÍA Y SEGMENTO,
-- MUESTRE EL PRODUCTO MÁS VENDIDO DE CADA CATEGORÍA Y SEGMENTO
USE SQL_EN_LLAMAS_ALUMNOS;
GO

-- Creación de la UDF			
CREATE OR ALTER FUNCTION case04.PNG_getBestSellingProduct (@category_id INT ,@segment_id INT)
RETURNS @table TABLE(best_selling_product_name NVARCHAR(MAX), total_quantity INT)
WITH EXECUTE AS CALLER
AS
BEGIN
	-- Creación y definición de variables para la validación de los parámetros de entrada
	DECLARE @min_category_id INT ,@max_category_id INT ,@min_segment_id INT ,@max_segment_id INT;

	SELECT 
		@min_category_id = MIN(category_id)
		,@max_category_id = MAX(category_id)
		,@min_segment_id = MIN(segment_id)
		,@max_segment_id = MAX(segment_id)
	FROM case04.product_details;

	-- COMPROBACIÓN DE PARÁMETROS DE ENTRADA VÁLIDOS
	IF (@category_id BETWEEN @min_category_id AND @max_category_id) AND (@segment_id BETWEEN @min_segment_id AND @max_segment_id)
		-- Ambos parámetros son válidos
		BEGIN
		WITH
			PREPARED_DATA AS (
				-- SELECT DISTINCT para eliminar los registros duplicados
				SELECT DISTINCT
					s.txn_id
					,s.qty
					,pd.product_name
				FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales AS s
				-- LEFT JOIN con product_details para obtener product_name
				LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details AS pd
					ON s.prod_id = pd.product_id
				-- WHERE para filtrar por los identificadores de categoría y segmento introducidos
				WHERE pd.category_id = @category_id
					AND pd.segment_id = @segment_id
			)

			,PRODUCT_RANKING AS (
				SELECT
					product_name
					,SUM(qty) AS total_quantity
					,DENSE_RANK() OVER (ORDER BY SUM(qty) DESC) AS dr
				FROM PREPARED_DATA
				GROUP BY product_name
			)

			,BEST_SELLING_PRODUCT AS (
				SELECT
					product_name
					,total_quantity
				FROM PRODUCT_RANKING
				WHERE dr = 1
			)

		-- Si no existe ningún resultado, la tabla estará vacía
		INSERT INTO @table
		SELECT
			product_name
			,total_quantity
		FROM BEST_SELLING_PRODUCT;

		-- COMPROBACIÓN DE LA EXISTENCIA DE UN RESULTADO FINAL
		IF (SELECT COUNT(*) FROM @table) = 0
			BEGIN
			DECLARE @all_combinations NVARCHAR(MAX);
			SELECT @all_combinations =
				STRING_AGG(sub.comb, ', ')
			FROM (
				SELECT DISTINCT CONCAT(pd.category_id, '-' ,pd.segment_id) AS comb
				FROM SQL_EN_LLAMAS_ALUMNOS.case04.sales AS s
				LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_details AS pd
					ON s.prod_id = pd.product_id ) AS sub

			-- No existe ningún resultado aunque la combinación de entrada sea correcta. Lanza un mensaje informativo
			INSERT INTO @table
			SELECT
				CONCAT(
					'NO EXISTE NINGÚN REGISTRO DE PRODUCTO VENDIDO CON LA SIGUIENTE COMBINACIÓN: CATEGORY_ID = ',
					@category_id, ', SEGMENT_ID = ', @segment_id,
					'. PRUEBE DE NUEVO CON ALGUNA DE LAS SIGUIENTES COMBINACIONES DISPONIBLES CATEGORY_ID-SEGMENT_ID: ',
					@all_combinations)
				,0
			END
		END
	
	-- COMPROBACIÓN DE PARÁMETROS DE ENTRADA INVÁLIDOS
	ELSE IF (@category_id NOT BETWEEN @min_category_id AND @max_category_id) AND (@segment_id NOT BETWEEN @min_segment_id AND @max_segment_id)
		-- Ambos parámetros son inválidos
		INSERT INTO @table
			SELECT
				CONCAT(
					'CATEGORY_ID, SEGMENT_ID INVÁLIDOS. PRUEBE CON VALORES DEFINIDOS EN EL RANGO [',
					@min_category_id, ',', @max_category_id, '] Y [', @min_segment_id, ',', @max_segment_id,
					'], RESPECTIVAMENTE PARA CADA UNO')
				,NULL

	ELSE IF @category_id NOT BETWEEN @min_category_id AND @max_category_id
		-- El parámetro category_id es inválido
		INSERT INTO @table
			SELECT
				CONCAT(
					'CATEGORY_ID INVÁLIDO. PRUEBE CON VALORES DEFINIDOS EN EL RANGO [',
					@min_category_id, ',', @max_category_id, '] ')
				,NULL

	ELSE
		-- El parámetro segment_id es inválido
		INSERT INTO @table
			SELECT
				CONCAT(
					'SEGMENT_ID INVÁLIDO. PRUEBE CON VALORES DEFINIDOS EN EL RANGO [',
					@min_segment_id, ',', @max_segment_id, '] ')
				,NULL
	RETURN
END;
GO


-- Ejecuciones de prueba
-- category_id, segment_id inválidos
SELECT * FROM case04.PNG_getBestSellingProduct(0, 0);
-- category_id inválido
SELECT * FROM case04.PNG_getBestSellingProduct(3, 4);
-- segment_id inválido
SELECT * FROM case04.PNG_getBestSellingProduct(1, 1);
-- category_id, segment_id válidos y sin resultado
SELECT * FROM case04.PNG_getBestSellingProduct(2, 4);
-- category_id, segment_id válidos y con resultado
SELECT * FROM case04.PNG_getBestSellingProduct(1, 3);


-- Eliminación de la UDF
DROP FUNCTION IF EXISTS case04.PNG_getBestSellingProduct;
