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

/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*
El resultado no es del todo correcto! Al igual que te comenté en el reto anterior
faltaría incluir al cliente D.

Puede que se te haya pasado, pero comentarte que se ha desarrollado una aplicación 
para poder comprobar si la solución que propones devuelve el resultado esperado:
    - Comprueba si devuelve el número esperado de filas.
    - Comprueba si devuelve el número esperado de columnas.
    - Al fallar un número determinado de veces te muestra la tabla de salida esperada.
Te recomiendo encarecidamente su uso que puede seros muy útil.
Enlace: https://sqlonfire.civica-soft.com/

No te desanimes pues ha sido un pequeño detalle para que estuviera correcto del todo, ánimo para los siguientes!!!

*/
