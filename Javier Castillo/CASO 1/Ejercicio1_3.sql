WITH PRODUCTOS_PEDIDOS
AS (
	SELECT DISTINCT C.customer_id AS CLIENTE
	  , S.order_Date
	  , COALESCE (M.product_name , '') AS PRODUCTO_PEDIDO
	  , RANK() OVER (PARTITION BY C.customer_id ORDER BY S.order_Date ASC)  as RN
	FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] AS C
	LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
		ON C.customer_id = S.customer_id
	LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] AS M
		ON S.product_id=M.product_id
)


SELECT 
CLIENTE
, STRING_AGG(PRODUCTO_PEDIDO, ', ') AS PRODUCTOS_PEDIDOS
FROM PRODUCTOS_PEDIDOS
  WHERE RN = 1
GROUP BY CLIENTE
ORDER BY CLIENTE;


/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Buen uso de la función de ventana RANK() para obtener el primer producto pedido por el cliente (haya empate o no).
Legibilidad: OK. El código es perfectamente legible, aunque podrías haber tabulado las columnas del select final.

Además, me ha gustado que agrupes los productos de un mismo cliente mediante la función STRING_AGG.

¡Enhorabuena!
*/
