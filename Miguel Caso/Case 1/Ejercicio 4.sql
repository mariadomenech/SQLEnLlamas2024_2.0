WITH total_pedidos AS (
    SELECT product_id, COUNT (product_id) AS num_pedidos
    FROM SQL_EN_LLAMAS.CASE01.SALES s
    GROUP BY product_id)
SELECT m.product_name, t.num_pedidos
    FROM total_pedidos t
    JOIN SQL_EN_LLAMAS.CASE01.MENU m ON t.product_id = m.product_id
    WHERE t.num_pedidos = (SELECT MAX(num_pedidos) FROM total_pedidos)
    ORDER BY m.product_name;
