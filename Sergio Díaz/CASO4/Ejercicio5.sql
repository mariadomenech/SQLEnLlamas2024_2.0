/* Alumno: Sergio Díaz */
/* CASO 4 - Ejercicio 5: Función para calcular producto más vendido dada una categoria y un segmento */


CREATE FUNCTION [dbo].[SDF_PRODUCTO_MAS_VENDIDO] ( --Función para el cálculo del producto más vendido por categoría y segmento
	@Categoria INT
	,@Segmento INT
	) 
RETURNS @TablaResultado TABLE -- Definimos la tabla de salida
	(
	Mensaje NVARCHAR(200)
	,Cantidad NVARCHAR(200)
	)

BEGIN
	IF ( --Chequeamos si existe la combinacion en la tabla		
			EXISTS (
				SELECT category_id
					,segment_id
				FROM case04.product_details
				WHERE category_id = @Categoria
					AND segment_id = @Segmento
				)
			)
	BEGIN
		WITH PROD_MAS_VENDIDO --CTE para calcular ranking de productos más vendidos por la categoria y segmento dados
		AS (	
			SELECT d.product_name
				,SUM(s.qty) AS n_veces_vendido
				,RANK() OVER (
					ORDER BY SUM(s.qty) DESC
					) AS Ranking
			FROM (
				SELECT DISTINCT *
				FROM case04.sales
				) s
			JOIN case04.product_details d ON s.prod_id = d.product_id
			WHERE d.category_id = @Categoria
				AND d.segment_id = @Segmento
			GROUP BY d.product_name
			)
		INSERT INTO @TablaResultado --Añadimos el resultado a la tabla final
		SELECT product_name
			,n_veces_vendido
		FROM PROD_MAS_VENDIDO
		WHERE Ranking = 1

		RETURN;
	END
	ELSE
	BEGIN -- Si no existe la combinación introducida
		INSERT INTO @TablaResultado -- Insertamos mensajes de salida en la tabla final avisando al usuario
		SELECT 'Combinacion introducida no válida'
			,CONCAT (
				'Combinaciones válidas: '
				,STRING_AGG(aux.combinacion, ' ')
				) 
		FROM (
			SELECT CONCAT (
					'['
					,category_id
					,','
					,segment_id
					,']'
					) AS combinacion
			FROM case04.product_details
			GROUP BY category_id
				,segment_id
			) aux

		RETURN;
	END

	RETURN
END;

----------- Sentencias de prueba de la función --------------

SELECT *
FROM dbo.SDF_PRODUCTO_MAS_VENDIDO(1, 3)

SELECT *
FROM dbo.SDF_PRODUCTO_MAS_VENDIDO(1, 2)

SELECT *
FROM dbo.SDF_PRODUCTO_MAS_VENDIDO(2, 5)

SELECT *
FROM dbo.SDF_PRODUCTO_MAS_VENDIDO(2, 6)

SELECT *
FROM dbo.SDF_PRODUCTO_MAS_VENDIDO(3, 6)


--------Eliminamos la función-----------
DROP FUNCTION SDF_PRODUCTO_MAS_VENDIDO
