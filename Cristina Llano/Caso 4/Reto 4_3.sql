/* Crea una única consulta SQL para replicar la tabla product_details, 
hay que transformar los conjuntos de datos product_hirarchy y product_price*/

SELECT price.product_id
  , price.price
  , CONCAT ( id.level_text,' ', parent_a.level_text, ' - ', parent_b.level_text) AS product_name
  , parent_a.parent_id AS category_id
  , id.parent_id AS segment_id
  , price.id AS style_id
  , parent_b.level_text AS category_name
  , parent_a.level_text AS segment_name
  , id.level_text AS style_name
FROM SQL_EN_LLAMAS_ALUMNOS.case04.product_prices price
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy id
	ON price.id = id.id
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy parent_a
--Hacemos control de nulos para no tener problemas al cruzar con nulos
	ON COALESCE(id.parent_id, -99) = parent_a.id 
--Hacemos control de nulos para no tener problemas al cruzar con nulos
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy parent_b
	ON COALESCE(parent_a.parent_id, -99) = parent_b.id
;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Enhorabuena Cristina, perfecto!!

Resultado: OK
Código: OK.
Legibilidad: OK.

Me ha gustado que tengas en cuenta el control de nulos.


*/
