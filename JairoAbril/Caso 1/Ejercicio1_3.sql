WITH rankingProducto AS (
    SELECT 
        CUSTOMERS.CUSTOMER_ID AS ID_CLIENTE
        , MENU.PRODUCT_NAME AS PRODUCTO
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
// además muestro un null cuando no tiene productos en lugar de vacio
