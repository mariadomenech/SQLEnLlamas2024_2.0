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
