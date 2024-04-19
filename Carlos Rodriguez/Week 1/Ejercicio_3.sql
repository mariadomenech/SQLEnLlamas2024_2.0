SELECT 
	c.customer_id,
        
	COALESCE(m.product_name,
        'sin pedido') AS 'pedido'
FROM case01.customers c
LEFT
JOIN (
SELECT s.customer_id,
        MIN(s.product_id) AS product_id

    FROM (
SELECT 
	customer_id,
        MIN(order_date) AS FirstOrderDate

    FROM case01.sales

    GROUP BY  customer_id) AS FirstOrders
JOIN case01.sales s
    ON FirstOrders.customer_id = s.customer_id
        AND FirstOrders.FirstOrderDate = s.order_date

    GROUP BY  s.customer_id
) AS FirstProducts
    ON c.customer_id = FirstProducts.customer_id
LEFT
JOIN case01.menu m
    ON FirstProducts.product_id = m.product_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

El resultado no es del todo correcto, ya que al quedarte con el MIN del producto, no sacas posibles empates. La forma más sencilla de sacarlo es mediantes la funcion RANK(), échale un vistazo!

*/
