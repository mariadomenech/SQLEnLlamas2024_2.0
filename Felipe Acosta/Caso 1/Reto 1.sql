-- RETO 1
-- ¿Cúanto ha gasto en total cada cliente en el restaurante?

WITH sales_with_price AS(
	SELECT A.customer_id, A.order_date , A.product_id, B.price
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales A
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu B ON (A.product_id= B.product_id)
)
SELECT customer_id Cliente, SUM(price) Total_gastado
FROM sales_with_price
GROUP BY customer_id