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

/****************************************/
/************COMENTARIO DANI*************/
/****************************************/
/*
Resultado correcto, buena legibilidad, me gusta el enfoque que le has dado al usar
una función como WITH TIES, sin embargo aunque en este caso esté completamente correcto
debes tener en cuenta que la función WITH TIES devolverá todos los productos que tengan
la misma cantidad de ventas que el producto con la cantidad mas alta, Si hay empates 
en la cantidad de pedidos (varios productos con la misma cantidad), WITH TIES 
incluirá todos los productos empatados en el resultado final. Aún así, te animo a que 
continues por estas sendas de exploración en este maravilloso mundo del SQL, sigue así
Ismael! Tu puedes!!*/
