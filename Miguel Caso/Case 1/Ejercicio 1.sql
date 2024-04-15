SELECT
    c.customer_id AS cliente,
    COALESCE (SUM (price),0) AS total_gasto
FROM SQL_EN_LLAMAS.CASE01.SALES a
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU b ON a.product_id = b.product_id
RIGHT JOIN SQL_EN_LLAMAS.CASE01.CUSTOMERS c ON a.customer_id = c.customer_id
GROUP BY c.customer_id;
