-- RETO 2
-- ¿Cúantos dias ha visitado el restaurante cada cliente?

SELECT A.customer_id Cliente, count(distinct B.order_date) Dias_visitados
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers A
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales B ON (A.customer_id = B.customer_id)
group by A.customer_id
order by 2 desc;