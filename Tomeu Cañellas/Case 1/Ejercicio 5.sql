--CASO 1: Ejercicio 5
SELECT  customers.customer_id,
        --Aplicamos la lógica de puntos, si es NULL sustituimos por 0
        SUM(
            ISNULL(CASE WHEN menu.product_id = 1 THEN menu.price * 2 * 10
	                ELSE menu.price * 10 END, 0)
            ) AS total_points		
from [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] customers
--Usamos LEFT JOIN para incluir los clientes sin ningún pedido
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
    ON customers.customer_id = sales.customer_id
--Usamos LEFT JOIN para incluir los clientes sin ningún pedido
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] menu
    ON menu.product_id = sales.product_id
--Agrupamos por clientes para obtener la suma de puntos de cada uno
GROUP BY customers.customer_id
--Ordenamos por cliente
ORDER BY 1;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*******************************************************/
/* 

Resultado y código: PERFECTO!

Legibilidad: Ok!

*/
