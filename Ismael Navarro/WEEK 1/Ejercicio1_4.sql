--Se podría usar la función rank, pero voy a optar por esta porque la veo más original. La función "TOP 1" con "WITH TIES" por si hay empate en el TOP que no deje resultados fuera.

WITH ProductosPedidos AS (
    SELECT PRODUCT_NAME, 
	COUNT(*) AS PedidosTotales
    FROM case01.sales s
    JOIN case01.menu m
		ON s.PRODUCT_ID = m.PRODUCT_ID
    GROUP BY PRODUCT_NAME
)
SELECT TOP 1 WITH TIES PRODUCT_NAME, PedidosTotales
FROM ProductosPedidos
ORDER BY PedidosTotales DESC;
