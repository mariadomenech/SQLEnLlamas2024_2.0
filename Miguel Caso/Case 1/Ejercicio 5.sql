WITH dinero_gastado AS (
    SELECT s.customer_id, m.product_name, CASE m.product_name WHEN 'sushi' THEN m.price * 20 ELSE m.price * 10 END AS puntos
    FROM SQL_EN_LLAMAS.CASE01.SALES s
    JOIN SQL_EN_LLAMAS.CASE01.MENU m ON s.product_id = m.product_id)
    
SELECT c.customer_id, COALESCE(SUM (puntos),0)
    FROM CASE01.CUSTOMERS c
    LEFT JOIN dinero_gastado d ON c.customer_id  = d.customer_id
    GROUP BY c.customer_id;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto
CÓDIGO: Correcto. Recuerda ponerle un alias cuando hagas funciones de este tipo para que tenga un nombre como "Puntos"
                o similar para que sea más comprensible el código. EJ: COALESCE(SUM (puntos),0) as Puntos
LEGIBILIDAD: Recuerda darle formato con las identaciones para que sea más facil la lectura del código.

Muy bien Miguel!!!

*/
