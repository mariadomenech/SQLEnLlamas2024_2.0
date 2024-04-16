SELECT c.customer_id, 
COUNT(DISTINCT s.order_date) as Dias_Visitados
FROM case01.customers c
LEFT JOIN case01.sales s ON c.customer_id = s.customer_id
GROUP BY c.customer_id;
