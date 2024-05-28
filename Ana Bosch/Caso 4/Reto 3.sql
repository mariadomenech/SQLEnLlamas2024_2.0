-- RETO 3: Crea una única consulta de sql para replicar la tabla de product_details. Para esto, hay que 
-- transformar los conjuntos de datos product_hierarchy y product_prices.

SELECT product_id
	,price
	,CONCAT(STY.level_text, ' ', SEG.level_text, ' - ', CAT.level_text) AS product_name
	,CAT.id AS category_id
	,SEG.id AS segment_id
	,STY.id AS style_id
	,CAT.level_text AS category_name
	,SEG.level_text AS segment_name
	,STY.level_text AS style_name
FROM case04.product_hierarchy CAT
-- Selfjoin para recorrer los nodos y obtener los diferentes segmentos por categoria
JOIN case04.product_hierarchy SEG
	ON CAT.id = SEG.parent_id
-- Selfjoin para recorrer los nodos y obtener los diferentes estilos por segmento y categoria
JOIN case04.product_hierarchy STY
	ON SEG.id = STY.parent_id
-- Join con la tabla prices para obtener el precio y el id_prodcut
JOIN case04.product_prices prices
	ON STY.id = prices.id
