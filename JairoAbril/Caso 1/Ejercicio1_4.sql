WITH NUM_PEDIDOS_PRODUCTOS AS (
    SELECT 
        m.PRODUCT_NAME as Producto, 
        COUNT(*) AS Num_Pedidos_Totales
    FROM case01.sales s
    JOIN case01.menu m ON s.PRODUCT_ID = m.PRODUCT_ID
    GROUP BY m.PRODUCT_NAME
),
Ranking_Productos AS (
    SELECT 
        Producto, 
        Num_Pedidos_Totales, 
        RANK() OVER (ORDER BY Num_Pedidos_Totales DESC) AS Ranking
    FROM NUM_PEDIDOS_PRODUCTOS 
)
SELECT 
    Producto, 
    Num_Pedidos_Totales
FROM Ranking_Productos 
WHERE Ranking = 1;
