SELECT
    a.customer_id AS cliente,
    COUNT (DISTINCT b.order_date) AS num_dias
FROM SQL_EN_LLAMAS_ALUMNOS.CASE01.CUSTOMERS a
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.CASE01.SALES b ON a.customer_id = b.customer_id
GROUP BY a.customer_id;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

Está correcto! 
En la última actualización de la app puse que se ordenase por num_dias de manera descendente, pero como has subido la solución antes del cambio pues....
VALIDA LA SOLUCIÓN! jejeje

Lo único nuevo es ponerle abajo del GROUP BY un ORDER BY:
ORDER BY num_dias desc;
*/
