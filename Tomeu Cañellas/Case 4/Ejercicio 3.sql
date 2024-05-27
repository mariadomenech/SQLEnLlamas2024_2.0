--CASO 4: Ejercicio 3
--Cruzamos la tabla de product_prices con product_hierarchy por sus respectivos id
SELECT 	pri.product_id,
	pri.price,
	CONCAT(hie.level_text, ' ', hier.level_text, ' - ', hiera.level_text) AS product_name,
	hiera.id AS category_id,
	hier.id AS segment_id,
	hie.id AS style_id,
	hiera.level_text AS category_name,
	hier.level_text AS segment_name,
	hie.level_text AS style_name
FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_prices] pri
INNER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] hie
	ON pri.id = hie.id
--Consideramos product_hierarchy como distintas tablas siguiendo una jerarquia que cruzaremos por id y parent_id
INNER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] hier
	ON hie.parent_id = hier.id
INNER JOIN [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] hiera
	ON hier.parent_id = hiera.id
;
