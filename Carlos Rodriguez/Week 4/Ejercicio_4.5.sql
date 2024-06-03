CREATE
        OR ALTER FUNCTION ejercicio_crm (@cat_ID INT,
        @seg_ID INT) 
RETURNS @outTable TABLE 
(
	product_name NVARCHAR(MAX) NOT NULL,
        
	cantidad_vendida INT
)
AS 
BEGIN
	DECLARE 
		@minCat INT,
        
		@maxCat INT,
        
		@minSeg INT,
        
		@maxSeg INT

	SELECT 
		@minCat = MIN(category_id),
        
		@maxCat = MAX(category_id),
        
		@minSeg = MIN(segment_id),
        
		@maxSeg = MAX(segment_id)
	FROM case04.product_details

	IF @cat_ID
    BETWEEN @minCat
        AND @maxCat 
	BEGIN
		IF @seg_ID
    BETWEEN @minSeg
        AND @maxSeg 
		BEGIN
			INSERT INTO @outTable
			SELECT 
				product_name,
        
				cantidad_vendida
			FROM (
				SELECT
					details.product_name,
        
					SUM(sales.qty) AS cantidad_vendida,
        
					RANK()
    OVER (ORDER BY SUM(sales.qty) DESC) AS ranking
				FROM (SELECT DISTINCT *
    FROM case04.sales) sales 
				JOIN case04.product_details details
					ON sales.prod_id = details.product_id
				WHERE details.category_id = @cat_ID
					AND details.segment_id = @seg_ID
				GROUP BY details.product_name
			) consulta
			WHERE ranking = 1 
		END
		ELSE
		BEGIN
			INSERT INTO @outTable
			SELECT
				CONCAT('Introduzca un segmento válido. (Entre ',
        CAST(@minSeg AS VARCHAR) ,
        ' y ',
        CAST(@maxSeg AS VARCHAR),
        ' ).'),
        
				NULL
		END
	END
	ELSE
	BEGIN
		INSERT INTO @outTable
		SELECT
			CONCAT('Introduzca una categoría válida. (Entre ',
        CAST(@minCat AS VARCHAR),
        ' y ',
        CAST(@maxCat AS VARCHAR),
        ' ).'),
        
			NULL
	END

	RETURN
END;
-- Ejecución --
SELECT * from ejercicio_crm (2,6);
SELECT * from ejercicio_crm (3,6);


-- Eliminación --
DROP FUNCTION ejercicio_crm;
