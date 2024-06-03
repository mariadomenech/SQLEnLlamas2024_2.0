-- RETO 5: Crea una función que, introduciéndole una categoría segmento, muestre el producto más vendido de cada categoría y segmento.

-- Función para devolver el producto más vendido y la cantidad vendida
CREATE OR ALTER FUNCTION getBestSellingProduct (@category INT, @segment INT)
RETURNS @result_table TABLE -- Como salida obtengo una tabla con las columnas producto y cantidad vendida
(	
	product_name NVARCHAR(256),
	qty_sold INT
)
AS
BEGIN
	-- Declaro variables 
	DECLARE 
		@Max_category INT, -- para controlar la entrada de categoria
		@Min_category INT, -- para controlar la entrada de categoria
		@Max_segment INT, -- para controlar la entrada de segmento
		@Min_segment INT -- para controlar la entrada de segmento

	-- Establezco el valor máximo y mínimo de categoría y segmento en función de la información que tenemos en la tabla detalle
	SELECT 
		@Max_category = MAX(category_id),
		@Min_category = MIN(category_id),
		@Max_segment = MAX(segment_id),
		@Min_segment = MIN(segment_id)
	FROM case04.product_details

	-- Control de entradas
	-- En caso de que la categoría sea incorrecta se devuelve una tabla con un msg de error indicando como debe hacerse la consulta
	IF @category NOT BETWEEN @Min_category AND @Max_category
		INSERT INTO @result_table 
			SELECT CONCAT('Categoría incorrecta pruebe con el intervalo: [',@Min_category,'-',@Max_category, ']'), 
				NULL
	-- En caso de que el segmetno sea incorrecto se devuelve una tabla con un msg de error indicando como debe hacerse la consulta
	ELSE IF @segment NOT BETWEEN @Min_segment AND @Max_segment
		INSERT INTO @result_table 
			SELECT CONCAT('Segmento incorrecto pruebe con el intervalo: [',@Min_segment,'-',@Max_segment, ']'), 
				NULL
	-- En caso de que la consulta sea correcta se realizan los cálculos para obtener el producto más vendido y la cantidad
	ELSE 
		-- Se calcula el ranking en una CTE 
		WITH CTE_RankByCategorySegment
		AS (
			SELECT category_id
					,segment_id
					,product_name
					,SUM(COALESCE(QTY,0)) AS cantidad_vendida
					,RANK() OVER(
						PARTITION BY category_id
							,segment_id 
						ORDER BY SUM(COALESCE(QTY,0)) DESC
					) ranking
				FROM case04.product_details product
				LEFT JOIN (SELECT DISTINCT * FROM case04.sales)/*case04.sales*/ sales
					ON product.product_id = sales.prod_id
				WHERE category_id = @category AND segment_id = @segment
				GROUP BY category_id
					,segment_id
					,product_name
		)

		-- Se devuelve la tabla resultado
		INSERT INTO @result_table SELECT product_name,
			cantidad_vendida
		FROM CTE_RankByCategorySegment
		WHERE ranking = 1
	RETURN
END

-- Ejecuciones de prueba
SELECT * FROM getBestSellingProduct (0,3);
SELECT * FROM getBestSellingProduct (1,0);
SELECT * FROM getBestSellingProduct (2,6);
SELECT * FROM getBestSellingProduct (1,3);

-- Borrar función
DROP FUNCTION getBestSellingProduct 
