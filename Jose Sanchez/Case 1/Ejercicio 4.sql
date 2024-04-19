SELECT
    TOP(1) menu.product_name,
    COUNT(sales.product_id) as units_sold
from
    case01.menu as menu
    LEFT JOIN case01.sales as sales ON menu.product_id = sales.product_id
GROUP BY
    sales.product_id,
    menu.product_name
ORDER BY
    units_sold DESC;

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

En resumen, muy bien Jose!!!

*/
