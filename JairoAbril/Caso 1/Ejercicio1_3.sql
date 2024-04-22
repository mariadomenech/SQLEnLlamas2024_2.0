WITH rankingProducto AS (
    SELECT 
        CUSTOMERS.CUSTOMER_ID AS ID_CLIENTE
        , COALESCE(MENU.PRODUCT_NAME, '') AS PRODUCTO
        , ROW_NUMBER() OVER (PARTITION BY CUSTOMERS.CUSTOMER_ID ORDER BY SALES.ORDER_DATE ASC) AS RANK
  
    FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers CUSTOMERS
    LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales SALES
        ON CUSTOMERS.CUSTOMER_ID = SALES.CUSTOMER_ID
    LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu MENU
        ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
)

SELECT ID_CLIENTE, PRODUCTO
FROM rankingProducto
WHERE RANK = 1;


//como aclaración se coje el producto con un menor id si existen productos con fechas de pedido similares ya que ambos se pidieron el mismo día
// además muestro un VACIO cuando no tiene productos en lugar de NULL

/*
Corrección Pablo: El ejercicio no está bien resuelto del todo (puedes comprobarlo en la aplicación) porque el cliente A pidió dos productos el
primer día, de modo que el objetivo era sacar ambos productos y no quedarse únicamente con el de menor id, no me queda claro por qué optaste por
ese criterio de desempate.

Resultado: NOK. Te falta un producto en el cliente A.
Código: NOK. En lugar de usar la función de ventana ROW_NUMBER() deberías haber usado la función RANK() o DENSE_RANK() que sí tiene en cuenta las 
situaciones de empate como ocurre en este ejercicio, además de la función STRING_AGG() para mostrar todos los productos pedidos por primera vez por 
un único cliente en una misma línea.
Legibilidad: OK. El código es perfectamente legible, a mí me encantan las CTEs.

Te animo a que lo reintentes y/o me comentes cualquier duda que te surja.
*/
