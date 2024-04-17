WITH RankedOrders AS (
    SELECT s.CUSTOMER_ID, m.PRODUCT_NAME,
           RANK() OVER(PARTITION BY s.CUSTOMER_ID ORDER BY s.ORDER_DATE) as rn
    FROM case01.sales s
    JOIN case01.menu m ON s.PRODUCT_ID = m.PRODUCT_ID
),
DistinctOrders AS (
    SELECT DISTINCT CUSTOMER_ID, PRODUCT_NAME
    FROM RankedOrders
    WHERE rn = 1
),
GroupedOrders AS (
    SELECT CUSTOMER_ID, STRING_AGG(PRODUCT_NAME, ', ') WITHIN GROUP (ORDER BY PRODUCT_NAME) as Products
    FROM DistinctOrders
    GROUP BY CUSTOMER_ID
)
SELECT c.CUSTOMER_ID, COALESCE(g.Products, 'sin pedido') AS Primer_Producto_Pedido
FROM case01.customers c
LEFT JOIN GroupedOrders g ON c.CUSTOMER_ID = g.CUSTOMER_ID
ORDER BY c.CUSTOMER_ID;
