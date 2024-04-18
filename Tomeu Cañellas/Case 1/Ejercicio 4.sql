--CASO 1: Ejercicio 4
-- Seleccionamos solo el producto con mayor número de pedidos
SELECT TOP 1 menu.product_name, 
             COUNT(sales.product_id) AS total_orders
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
-- Usamos LEFT JOIN para obtener la totalidad de los productos de la tabla 'menu'
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] menu
    ON menu.product_id = sales.product_id
-- Agrupamos por producto
GROUP BY menu.product_name
-- Ordenamos los productos de mayor a menor número de pedidos
ORDER BY 2 DESC;