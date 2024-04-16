SELECT 
    A.customer_id AS CLIENTE,
    COUNT(A.order_date) AS DIAS_VISITADOS
FROM (
    SELECT 
        customer_id,
        order_date
    FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
    GROUP BY customer_id, order_date
) AS A
GROUP BY customer_id;