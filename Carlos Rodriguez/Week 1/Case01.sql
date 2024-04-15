SELECT c.customer_id, COALESCE(SUM(m.price), 0) as Total_Gastado
FROM case01.customers c
LEFT JOIN case01.sales s ON c.customer_id = s.customer_id
LEFT JOIN case01.menu m ON s.product_id = m.product_id
GROUP BY c.customer_id;
