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
CÓDIGO: Correcto
LEGIBILIDAD: Correcta

Perfecto Miguel!!!

Te enseño otra solución para que veas otra forma de hacer el ejercicio sin tener que hacer una subconsulta:
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

*/
