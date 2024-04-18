-- RETO 1
-- ¿Cúanto ha gasto en total cada cliente en el restaurante?

WITH sales_with_price AS(
	SELECT A.customer_id, B.order_date , B.product_id, ISNULL(C.price, 0) price
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers A
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales B ON (A.customer_id = B.customer_id)
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu C ON (B.product_id= C.product_id)
)
SELECT customer_id Cliente, SUM(price) Total_gastado
FROM sales_with_price
GROUP BY customer_id;
