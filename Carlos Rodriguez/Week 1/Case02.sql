SELECT c.customer_id, 
COUNT(DISTINCT s.order_date) as Dias_Visitados
FROM case01.customers c
LEFT JOIN case01.sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Correcto! Buen uso de Distinct para evitar contabilizar fechas repetidas.

Sobre la legibilidad del código la mejoraría un poco separando los campos del select y los ONs de los joins:

SELECT 
      c.customer_id, 
      COUNT(DISTINCT s.order_date) as Dias_Visitados
FROM case01.customers c
LEFT JOIN case01.sales s 
    ON c.customer_id = s.customer_id
GROUP BY c.customer_id;

*/
