CREATE OR ALTER FUNCTION AMR_FUNCION_MAS_VENDIDO(@CATEGORIA INTEGER, @SEGMENTO INTEGER)

RETURNS @TABLA TABLE
(PRODUCT_NAME VARCHAR(150),
CANTIDAD_VENDIDA INTEGER)

AS

BEGIN

	DECLARE @MIN_CAT AS INTEGER
	DECLARE @MAX_CAT AS INTEGER
	DECLARE @CONCAT_CAT_SEG AS VARCHAR(5)
	DECLARE @SEG_BY_CAT AS VARCHAR(5)

	--AQUÍ GUARDO LA CADENA QUE ACABAMOS DE METER EN LA FUNCIÓN
	SELECT 
		@CONCAT_CAT_SEG = CONCAT(CAST(@CATEGORIA AS VARCHAR(1)),CAST(@SEGMENTO AS VARCHAR(1)))

	--AQUÍ GRUARDO LOS VALORES MINIMOS Y MAXIMOS DE CATEGORIA
	SELECT 
		@MIN_CAT = MIN(CATEGORY_ID),
		@MAX_CAT = MAX(CATEGORY_ID)
	FROM CASE04.PRODUCT_DETAILS

	--GUARDO EN OTRA VARIABLE LOS VALORES PLAUSIBLES DE SEGMENTO DE LA CATEGORÍA INTRODUCIDA
	SELECT
		@SEG_BY_CAT = STRING_AGG(SEGMENT_ID,', ')
	FROM (SELECT DISTINCT CATEGORY_ID, SEGMENT_ID FROM CASE04.PRODUCT_DETAILS) A
	WHERE CATEGORY_ID = @CATEGORIA

	--VEMOS SI LA CATEGORIA INTRODUCIDA ESTÁ ENTRE LOS VALORES MÍNIMOS Y MAXIMOS
	IF  @CATEGORIA BETWEEN @MIN_CAT AND @MAX_CAT

	--SI LA CATEGORIA INTRODUCIDA ES CORRECTA, VEMOS SI EL SEGMENTO INTRODUCIDO ESTÁ EN LA LISTA DE SEGMENTOS ASOCIADOS
	IF 	@CONCAT_CAT_SEG IN (
					SELECT DISTINCT 
						CONCAT(CAST(CATEGORY_ID AS VARCHAR(1)), CAST(SEGMENT_ID AS VARCHAR(1))) AS CAT_SEG
					FROM  CASE04.PRODUCT_DETAILS)

		INSERT @TABLA
		SELECT
			PRODUCT_NAME,
			CANTIDAD_VENDIDA
		FROM(SELECT 
				CATEGORY_ID,
				SEGMENT_ID,
				PRODUCT_NAME AS PRODUCT_NAME,
				SUM(QTY) AS CANTIDAD_VENDIDA,
				RANK() OVER (PARTITION BY CATEGORY_ID, SEGMENT_ID ORDER BY SUM(QTY) DESC) AS RANK
			FROM (SELECT DISTINCT * FROM CASE04.SALES) A
			JOIN CASE04.PRODUCT_DETAILS B ON A.PROD_ID = B.PRODUCT_ID
			GROUP BY
				CATEGORY_ID,
				SEGMENT_ID,
				PRODUCT_NAME) A
		WHERE 
			CATEGORY_ID = @CATEGORIA AND
			SEGMENT_ID  = @SEGMENTO AND
			RANK=1
	--MENSAJE SI LA CATEGORIA INTRODUCIDA NO ES VALIDA
	ELSE
		INSERT @TABLA
		SELECT 
			CONCAT('Para la categoría ',CAST(@CATEGORIA AS VARCHAR),', esta es la lista de segmentos validos: ',@SEG_BY_CAT,'.'),
			null
	--MENSAJE SI LA CATEOGRÍA ES BUENA PERO EL SEGMENTO NO CORRESPONDE A ESA CATEGORÍA
	ELSE
		INSERT @TABLA
		SELECT 
			CONCAT('Seleccione una categoría válida entre los valores ',CAST(@MIN_CAT AS VARCHAR),' y ',CAST(@MAX_CAT AS VARCHAR),'.'),
			null
	RETURN

END;

--SE PRUEBA LA FUNCION
SELECT * FROM AMR_FUNCION_MAS_VENDIDO(2,6);
SELECT * FROM AMR_FUNCION_MAS_VENDIDO(0,6);
SELECT * FROM AMR_FUNCION_MAS_VENDIDO(1,6);
SELECT * FROM AMR_FUNCION_MAS_VENDIDO(2,3);

--BORRAMOS
DROP FUNCTION IF EXISTS  AMR_FUNCION_MAS_VENDIDO;