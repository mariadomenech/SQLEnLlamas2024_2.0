-- RETO 2
-- ¿Cúantos dias ha visitado el restaurante cada cliente?

SELECT A.customer_id Cliente, count(distinct B.order_date) Dias_visitados
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers A
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales B ON (A.customer_id = B.customer_id)
group by A.customer_id
order by 2 desc;

/********************************************/
/************COMENTARIO DANI*****************/
/********************************************/
/* Resultado correcto, buen apuntado de tablas, lo único sería 
mejorar la legibilidad del código, te animo a que lo corrijas 
y me lo dejes bajo el comentario Felipe!. Quitando ese detallito 
todo correcto! Enhorabuena y a por mas!*/
