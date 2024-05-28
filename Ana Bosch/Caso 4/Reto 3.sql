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

---------------------------------------------------------------------- IMPORTANT!------------------------------------------------------------------------

/* SOLUCIÓN 2.0
Junto con Joram, nos hemos dado cuenta que estabamos frente a un claro ejemplo de recursividad por lo tanto hemos considerado buena solución 
el uso de CTE como caso base (recordando algoritmos recursivos) del cual partamos para recorrer recursivamente los nodos padres
PD: Es una solución más compleja que la inicial pero nos hacía bastante ilusión incorporarla */

-- CTE del caso base (categoria)
WITH CTE_CATEGORIA
AS (
	SELECT CAT.id AS CAT_id
		,CAT.level_text AS CAT_level_text
	FROM case04.product_hierarchy CAT
	WHERE level_name = 'Category'
),

-- CTE para a partir del caso base recurrentemente recorrer los ids padres para obtener el segmento
CTE_SEGMENTO
AS (
	SELECT CAT_id
		,SEG.id AS SEG_id
		,CAT_level_text
		,SEG.level_text AS SEG_level_text
	FROM CTE_CATEGORIA CAT
	JOIN case04.product_hierarchy SEG
		ON CAT.CAT_id = SEG.parent_id
	WHERE level_name = 'Segment'
),

-- CTE para recurrentemente recorrer los ids padres para obtener el estilo
CTE_STYLE
AS (
	SELECT CONCAT(STY.level_text, ' ', SEG_level_text, ' - ', CAT_level_text) AS product_name
		,CAT_id AS category_id
		,SEG_id AS segment_id
		,STY.id AS style_id
		,CAT_level_text AS category_name
		,SEG_level_text AS segment_name
		,STY.level_text AS style_name
	FROM CTE_SEGMENTO SEG
	JOIN case04.product_hierarchy STY
		ON SEG.SEG_id = STY.parent_id
	WHERE level_name = 'Style'
)

-- Consulta final para cruzar por product_id y price y obtener la tabla en el formato indicado
SELECT product_id
	,price
	,STY.*
FROM CTE_STYLE STY
JOIN case04.product_prices prices
	ON STY.style_id = prices.id

	
