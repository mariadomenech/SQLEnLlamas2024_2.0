SELECT
    customers.customer_id,
    ISNULL (sum(menu.price), 0)
FROM
    case01.customers as customers
    LEFT JOIN case01.sales as sales ON customers.customer_id = sales.customer_id
    LEFT JOIN case01.menu as menu ON menu.product_id = sales.product_id
GROUP BY
    customers.customer_id;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

Perfecto Jose!!!

*/
