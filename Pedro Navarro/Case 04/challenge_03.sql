-- RETO 3. ¿CREA UNA ÚNICA CONSULTA SQL PARA REPLICAR LA TABLA PRODUCT_DETAILS.
-- HAY QUE TRANSFORMAR LOS CONJUNTOS DE DATOS PRODUCT_HIERARCHY Y PRODUCT_PRICES
SELECT
	pp.product_id
	,pp.price
	,CONCAT(ph_style.level_text, ' ', ph_segment.level_text, ' - ', ph_category.level_text) AS product_name
	,ph_category.id AS category_id
	,ph_segment.id AS segment_id
	,ph_style.id AS style_id
	,ph_category.level_text AS category_name
	,ph_segment.level_text AS segment_name
	,ph_style.level_text AS style_name
FROM SQL_EN_LLAMAS_ALUMNOS.case04.product_prices AS pp
-- Primer JOIN con id de pp que equivale a style_id de product_retails
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy AS ph_style
	ON pp.id = ph_style.id
-- Segundo JOIN con parent_id de ph_style que equivale a segment_id de product_retails
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy AS ph_segment
	ON ph_style.parent_id = ph_segment.id
-- Tercer JOIN con parent_id de ph_segment que equivale a category_id de product_retails
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case04.product_hierarchy AS ph_category
	ON ph_segment.parent_id = ph_category.id;
