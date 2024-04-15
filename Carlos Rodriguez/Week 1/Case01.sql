SELECT customers.customer_id, COALESCE(SUM(menu.price), 0) as Total_Gastado
FROM case01.customers customers
LEFT JOIN case01.sales sales ON customers.customer_id = sales.customer_id
LEFT JOIN case01.menu menu ON sales.product_id = menu.product_id
GROUP BY customers.customer_id;
