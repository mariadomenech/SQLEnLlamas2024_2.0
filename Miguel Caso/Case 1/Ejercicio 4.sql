WITH total_pedidos AS (
    SELECT product_id, COUNT (product_id) AS num_pedidos
    FROM SQL_EN_LLAMAS.CASE01.SALES s
    GROUP BY product_id)
SELECT m.product_name, t.num_pedidos
    FROM total_pedidos t
    JOIN SQL_EN_LLAMAS.CASE01.MENU m ON t.product_id = m.product_id
    WHERE t.num_pedidos = (SELECT MAX(num_pedidos) FROM total_pedidos)
    ORDER BY m.product_name;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto
CÓDIGO: Correcto --> Es correcto, pero lo más eficiente hubiese sido usar la función rank,
que lo que hace es saber la posición exacta de cada fila dentro de un conjunto de resultados, considerando empates o
filtrar o analizar datos basados en su rango, como seleccionar todos los productos que están en el top 10, incluyendo empates.

Diferencia entre la función TOP y RANK --> Principalmente el manejo de los empates. Mientras TOP no maneja empates, RANK sí.
Si utilizas TOP 1, obtendrás un solo registro, incluso si hay varios registros que empatan en el primer lugar según el criterio especificado.

LEGIBILIDAD: Correcta

En resumen, muy bien Miguel!!!

*/
