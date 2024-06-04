/*Crea un afunción que, introduciéndole una categoría y segmento, muestre el producto más vendido de cada categoría y segmento.*/

USE [SQL_EN_LLAMAS_ALUMNOS]
GO
-- Ulizamos el use con el nombre de la bbdd con el fin de que no tengamos que hacer validaciones extras

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER FUNCTION CLN_Producto_Mas_Vendido
(	-- Parámetros recibidos
	@categoria INT,
	@segmento INT
)
RETURNS @tabla_salida TABLE
(
	des_producto NVARCHAR(MAX)
	, num_ventas INT 
)
AS
BEGIN

	DECLARE @id_categoria INT = @categoria
		, @id_segmento INT = @segmento
		, @categoria_existe INT = 0
		, @segmento_existe INT = 0
	-- Podría validar con el rango between pero si este rango cambia, es decir algún número se salta bien porque no deba existir o porque se elimina de la tabla no sería correcto.

	-- Por lo que se valida con un case mediante lo valores distinctos		
	SELECT @categoria_existe = CASE WHEN @id_categoria IN (SELECT distinct category_id FROM case04.product_details) THEN 1 ELSE 0 END 
		    , @segmento_existe = CASE WHEN @id_segmento IN (SELECT distinct segment_id FROM case04.product_details) THEN 1 ELSE 0 END 	
		
	IF @categoria_existe = 0 OR @segmento_existe = 0
		INSERT @tabla_salida
		SELECT 'La categoria '+ CAST(@id_categoria AS VARCHAR(40)) + ' o segmento ' + CAST(@id_segmento AS VARCHAR(40)) + ' introducido no existen' AS des_producto
		  , 0 AS num_ventas
	ELSE 
	-- Validamos que existen los datos introducidos
		INSERT @tabla_salida
		SELECT des_producto
			  , num_ventas
		FROM (
			SELECT detalle.product_name AS des_producto
			  , SUM(ventas.qty) AS num_ventas
			  , RANK() OVER (ORDER BY SUM(ventas.qty) DESC) as rn
			-- La tabla tiene duplicados puros, por lo que para no mantenerlos hacemos limpieza
			FROM (SELECT DISTINCT * FROM case04.sales) ventas
			INNER JOIN case04.product_details detalle
				ON  detalle.category_id = @id_categoria
				AND detalle.segment_id = @id_segmento
				AND ventas.prod_id = detalle.product_id
			GROUP BY detalle.product_name
		) base
		WHERE base.rn = 1  
	RETURN
END;

-- Existe en la bbdd
SELECT * FROM SQL_EN_LLAMAS_ALUMNOS.dbo.CLN_Producto_Mas_Vendido (2, 6);
-- Valores inventados
SELECT * FROM SQL_EN_LLAMAS_ALUMNOS.dbo.CLN_Producto_Mas_Vendido (12, 6);
SELECT * FROM SQL_EN_LLAMAS_ALUMNOS.dbo.CLN_Producto_Mas_Vendido (2, 66);
-- Valores insertados correctos pero sin información 
SELECT * FROM SQL_EN_LLAMAS_ALUMNOS.dbo.CLN_Producto_Mas_Vendido (2, 1);
