SELECT customers.customer_id, COALESCE(SUM(menu.price), 0) as Total_Gastado
FROM case01.customers customers
LEFT JOIN case01.sales sales ON customers.customer_id = sales.customer_id
LEFT JOIN case01.menu menu ON sales.product_id = menu.product_id
GROUP BY customers.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Correcto! Buen uso de joins y control de nulos.

Sobre la legibilidad del código la mejoraría un poco separando los campos del select y los ONs de los joins:

SELECT 
      customers.customer_id
    , COALESCE(SUM(menu.price), 0) as Total_Gastado
FROM case01.customers customers
LEFT JOIN case01.sales sales 
    ON customers.customer_id = sales.customer_id
LEFT JOIN case01.menu menu 
    ON sales.product_id = menu.product_id
GROUP BY customers.customer_id;

*/
