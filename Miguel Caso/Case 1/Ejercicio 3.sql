WITH CTE AS(
    SELECT
        DISTINCT me.customer_id cliente,
        m.product_name, 
        s.order_date,
        RANK() OVER(PARTITION BY me.customer_id ORDER BY s.order_date) AS SEQ
    FROM SQL_EN_LLAMAS.CASE01.CUSTOMERS me
        LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES s ON me.customer_id = s.customer_id
        LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU m ON s.product_id = m.product_id
) 
SELECT 
     cliente,
     COALESCE(STRING_AGG(product_name, ', '),' ') AS "PRIMER PRODUCTO QUE HA PEDIDO"
FROM CTE
WHERE SEQ = 1
GROUP BY cliente
ORDER BY cliente;
