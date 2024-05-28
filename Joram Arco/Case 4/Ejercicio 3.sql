SELECT
	pp.product_id
	,pp.price
	,CONCAT(CONCAT(ph.level_text, ' ', ph2.level_text), ' - ', ph3.level_text) as product_name
	,ph3.id as category_id
	,ph2.id as segment_id
	,ph.id as style_id
	,ph3.level_text as category_name
	,ph2.level_text as segment_name
	,ph.level_text as style_name
FROM case04.product_prices pp
JOIN case04.product_hierarchy ph
	ON pp.id = ph.id
JOIN case04.product_hierarchy ph2 
	ON ph.parent_id = ph2.id
JOIN case04.product_hierarchy ph3
	ON ph2.parent_id = ph3.id

	
/* SOLUCIÓN 2.0
He estado dando vueltas con Ana para ver cómo utilizar recursividad para resolver el ejercicio y hemos llegado a la conclusión
de que otra forma de solucionar el problema es el uso de CTE recursivo, usando tablas temporales pra generar los valores,
pero esta vez utilizando la columna level_name de la tabla product_hierarchy para dividir por esta */

-- En primer lugar recuperamos las filas que tienen el valor Category en la columna level_name
WITH category AS
(
    SELECT 
        id AS category_id
        ,level_text AS category_name
    FROM case04.product_hierarchy 
    WHERE level_name = 'Category'
), 

/* En segundo lugar recuperamos las filas que tienen el valor Segment y además comparamos con las que hemos
creado en la tabla anterior para recuperar su jerarquía también */
segment AS
(   
    SELECT 
        category.category_id
        ,ph.id AS segment_id 
        ,category.category_name
        ,ph.level_text AS segment_name
    FROM case04.product_hierarchy ph
    JOIN category category ON ph.parent_id = category.category_id
    WHERE level_name = 'Segment'
)

/* Por último, recuperamos el resto de información con el valor Style que es el que nos queda, además de añadir
el resto de campos restantes para recrear la tabla inicial que se pedía */
SELECT
    pp.product_id
    ,pp.price
    ,CONCAT(ph.level_text, ' ', segment_name, ' - ', category_name) AS product_name
    ,category_id
    ,segment_id 
    ,ph.id AS style_id
    ,category_name
    ,segment_name
    ,ph.level_text AS style_name
FROM case04.product_hierarchy ph
JOIN case04.product_prices pp 
	ON ph.id = pp.id
JOIN segment segment 
	ON ph.parent_id = segment.segment_id
WHERE level_name = 'Style';
