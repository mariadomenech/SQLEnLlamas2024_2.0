
WITH NUM_PEDIDOS_PRODUCTOS AS (
    SELECT 
        m.PRODUCT_NAME, 
        COUNT(*) AS PedidosTotales
    FROM case01.sales s
    JOIN case01.menu m ON s.PRODUCT_ID = m.PRODUCT_ID
    GROUP BY m.PRODUCT_NAME
),
Ranking_Productos AS (
    SELECT 
        PRODUCT_NAME, 
        PedidosTotales, 
        RANK() OVER (ORDER BY PedidosTotales DESC) AS Ranking
    FROM NUM_PEDIDOS_PRODUCTOS 
)
SELECT 
    PRODUCT_NAME, 
    PedidosTotales
FROM Ranking_Productos 
WHERE Ranking = 1;
