/* CREACIÓN DE FUNCIONES */
-- Función para el cálculo del producto más vendido en cada categoría y segmento
CREATE OR ALTER FUNCTION dbo.ProductoMasVendido(@cat_ID INT, @seg_ID INT) 
RETURNS @outTable TABLE --Declaramos la variable devuelta que en este caso será una tabla con el nombre del producto y la cantidad
(
	product_name NVARCHAR(MAX) NOT NULL
	,cantidad_vendida INT
)
AS 
BEGIN
	DECLARE --Declaramos las variables para obtener de la dimensión el mínimo y máximo de categoría y segmento
		@minCat INT
		,@maxCat INT
		,@minSeg INT
		,@maxSeg INT

	SELECT 
		@minCat = MIN(category_id)
		,@maxCat = MAX(category_id)
		,@minSeg = MIN(segment_id)
		,@maxSeg = MAX(segment_id)
	FROM case04.product_details

	IF @cat_ID BETWEEN @minCat AND @maxCat --Comprobamos que la categoría introducida existe en la tabla de dimensión
		IF @seg_ID BETWEEN @minSeg AND @maxSeg --Comprobamos que el segmento introducido existe en la tabla de dimensión
			INSERT @outTable
			SELECT --Obtenemos el nombre del producto y la cantidad y se lo pasamos a la tabla que devuelve la función
				product_name
				,cantidad_vendida
			FROM (
				SELECT
					details.product_name as product_name
					,SUM(sales.qty) as cantidad_vendida
					,RANK() OVER (ORDER BY SUM(sales.qty) DESC) as ranking
				FROM (SELECT DISTINCT * FROM case04.sales) sales --Quitamos registros duplicados
				JOIN case04.product_details details
					ON sales.prod_id = details.product_id
				WHERE details.category_id = @cat_ID
					AND details.segment_id = @seg_ID
				GROUP BY details.product_name
			) consulta
			WHERE ranking = 1 --Obtenemos el ranking 1 para que obtenga el más vendido
		ELSE --Si el segmento no está en la tabla de dimensión devuelve un mensaje de error indicándolo
			INSERT @outTable
			SELECT
				CONCAT('Introduzca un segmento válido. (Entre ', CAST(@minSeg AS VARCHAR) ,' y ', CAST(@maxSeg AS VARCHAR), ' ).')
				,null
	ELSE --Si la categoría no está en la tabla de dimensión devuelve un mensaje de error indicándolo
		INSERT @outTable
		SELECT
				CONCAT('Introduzca una categoría válida. (Entre ', CAST(@minCat AS VARCHAR), ' y ', CAST(@maxCat AS VARCHAR), ' ).')
				,null
	RETURN
END;


/* PRUEBAS DE EJECUCIONES */
SELECT * from ProductoMasVendido (2,6);
SELECT * from ProductoMasVendido (2,7);
SELECT * from ProductoMasVendido (3,6);


/* ELIMINACIÓN DE LAS FUNCIONES */
DROP FUNCTION ProductoMasVendido;



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Perfecto Joram!


Código: controlas todas las casuísticas
Legibilidad: OK
Resultado: OK
*/
