--CASO 4: Ejercicio 5
--Creamos el Stored Procedure
CREATE PROCEDURE BestSellerProduct
    @CategoryID INT,
    @SegmentID INT
AS
BEGIN
    -- Mejora ligeramente el rendimiento del SP al no devolver el mensaje de 'X rows affected'
    SET NOCOUNT ON;

    --Declaramos las variables de valor mínimo y máximo de los rangos aceptados
    DECLARE @MinCategoryID INT, @MaxCategoryID INT;
    DECLARE @MinSegmentID INT, @MaxSegmentID INT;

    -- Obtenemos los valores mínimo y máximo de category_id y segment_id
    SELECT  @MinCategoryID = MIN(category_id), 
            @MaxCategoryID = MAX(category_id)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details];
    
    SELECT  @MinSegmentID = MIN(segment_id), 
            @MaxSegmentID = MAX(segment_id)
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details];

    -- Validamos los parámetros de entrada
    IF (@CategoryID < @MinCategoryID OR @CategoryID > @MaxCategoryID) AND
       (@SegmentID < @MinSegmentID OR @SegmentID > @MaxSegmentID)
    BEGIN
        -- Mensaje de error si ambos parámetros no son válidos
        PRINT 'Invalid category_id and segment_id. Please provide category_id between ' + CAST(@MinCategoryID AS VARCHAR) + 
        ' and ' + CAST(@MaxCategoryID AS VARCHAR) + ', and segment_id between ' + CAST(@MinSegmentID AS VARCHAR) + ' and ' + CAST(@MaxSegmentID AS VARCHAR) + '.';
        RETURN;
    END
    ELSE IF (@CategoryID < @MinCategoryID OR @CategoryID > @MaxCategoryID)
    BEGIN
        -- Mensaje de error si el category_id no está dentro del rango de valores aceptados
        PRINT 'Invalid category_id. Please provide a value between ' + CAST(@MinCategoryID AS VARCHAR) + ' and ' + CAST(@MaxCategoryID AS VARCHAR) + '.';
        RETURN;
    END
    ELSE IF (@SegmentID < @MinSegmentID OR @SegmentID > @MaxSegmentID)
    BEGIN
        -- Mensaje de error si el segment_id no está dentro del rango de valores aceptados
        PRINT 'Invalid segment_id. Please provide a value between ' + CAST(@MinSegmentID AS VARCHAR) + ' and ' + CAST(@MaxSegmentID AS VARCHAR) + '.';
        RETURN;
    END

    -- Si los parámetros son válidos, ejecutamos la consulta
    SELECT TOP 1 details.product_name, 
                 SUM(sales.qty) AS units_sold
    FROM (SELECT DISTINCT * FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales]) sales
    LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details] details
        ON sales.prod_id = details.product_id
    WHERE details.category_id = @CategoryID AND details.segment_id = @SegmentID
    GROUP BY details.product_name
    ORDER BY units_sold DESC;
END
;

--Tests:
EXEC BestSellerProduct @CategoryID = 1, @SegmentID = 3;
EXEC BestSellerProduct @CategoryID = 1, @SegmentID = 2;
EXEC BestSellerProduct @CategoryID = 5, @SegmentID = 3;
EXEC BestSellerProduct @CategoryID = 5, @SegmentID = 1;

--Drop:
DROP PROCEDURE BestSellerProduct; 
