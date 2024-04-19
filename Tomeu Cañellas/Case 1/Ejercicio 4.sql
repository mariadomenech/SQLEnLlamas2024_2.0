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

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

El resultado es correcto para este caso, pero con el TOP 1 tenemos el problema de que si hay empate en el primer 
puesto no devolvería todos los resultados y vamos a intentar que, además de resultados correctos,el código pueda 
contemplar este tipo de casos.
Para mejorarlo podríamos utilizar RANK() o DENSE_RANK() como en el ejercicio 3 o la solución para utilizarlo con 
el TOP sería añadir el parámetro WITH TIES (que siempre tiene que ir acompañado de un ORDER BY)
que, en caso de empate, te muestra todas las filas que lo componen:

SELECT TOP 1 WITH TIES menu.product_name, -- sólo he añadido el WITH TIES
             COUNT(sales.product_id) AS total_orders
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
-- Usamos LEFT JOIN para obtener la totalidad de los productos de la tabla 'menu'
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] menu
    ON menu.product_id = sales.product_id
-- Agrupamos por producto
GROUP BY menu.product_name
-- Ordenamos los productos de mayor a menor número de pedidos
ORDER BY 2 DESC;

El resto de apartados como siempre genial, sólo el detalle ese para terminar de mejorarlo.
Ánimo que terminamos la semana!

*/
