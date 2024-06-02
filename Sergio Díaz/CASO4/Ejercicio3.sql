/* Alumno: Sergio Díaz */
/* CASO 4 - Ejercicio 3: Replicar la tabla product_details */

WITH CATEGORIAS -- Creamos una CTE de dimensión de categorias
AS (
	SELECT id
		,CASE 
			WHEN level_name = 'Category'
				THEN level_text
			END AS 'category_name'
	FROM case04.product_hierarchy
	WHERE CASE 
			WHEN level_name = 'Category'
				THEN level_text
			END IS NOT NULL
	)
	,SEGMENTOS -- Creamos una CTE de dimensión de segmentos
AS (
	SELECT id
		,CASE 
			WHEN level_name = 'Segment'
				THEN level_text
			END AS 'segment_name'
		,parent_id
	FROM case04.product_hierarchy
	WHERE CASE 
			WHEN level_name = 'Segment'
				THEN level_text
			END IS NOT NULL
	)
	,ESTILOS -- Creamos una CTE de dimensión de segmentos
AS (
	SELECT id
		,CASE 
			WHEN level_name = 'Style'
				THEN level_text
			END AS 'style_name'
		,parent_id
	FROM case04.product_hierarchy
	WHERE CASE 
			WHEN level_name = 'Style'
				THEN level_text
			END IS NOT NULL
	)
	
	
SELECT p.product_id -- Select final para crear la tabla resultando, igual a la product_details
	,p.price
	,CONCAT (
		e.style_name
		,' '
		,s.segment_name
		,' - '
		,c.category_name
		) AS product_name
	,c.id AS category_id
	,s.id AS segment_id
	,e.id AS style_id
	,c.category_name
	,s.segment_name
	,e.style_name
FROM SEGMENTOS s
JOIN CATEGORIAS c 
ON s.parent_id = c.id
JOIN ESTILOS e 
ON s.id = e.parent_id
JOIN case04.product_prices p 
ON p.id = e.id;
