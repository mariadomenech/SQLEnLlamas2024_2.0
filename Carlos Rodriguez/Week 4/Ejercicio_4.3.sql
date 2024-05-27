SELECT
    pp.product_id, 
    pp.price,
    CONCAT_WS(' - ', ph3.level_text, ph2.level_text, ph.level_text) AS product_name, --CONCAT_WS--Concatena los niveles de jerarquía del producto con un guion como separador para formar el nombre del producto
    ph3.id AS category_id, 
    ph2.id AS segment_id,
    ph.id AS style_id, 
    ph3.level_text AS category_name, 
    ph2.level_text AS segment_name, 
    ph.level_text AS style_name 
FROM
    case04.product_prices pp 
JOIN
    case04.product_hierarchy ph 
    ON pp.id = ph.id
JOIN
    case04.product_hierarchy ph2 
    ON ph.parent_id = ph2.id
JOIN
    case04.product_hierarchy ph3 
    ON ph2.parent_id = ph3.id;
