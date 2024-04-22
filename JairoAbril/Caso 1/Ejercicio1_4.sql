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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Buen uso de la función de ventana RANK() para obtener el producto más vendido (haya empate o no), aunque podrías 
haberte ahorrado una CTE aplicando el RANK() directamente en la primera con ORDER BY COUNT(*) DESC dentro de la función de ventana.
Legibilidad: OK. El código es perfectamente legible..

¡Enhorabuena!
*/
