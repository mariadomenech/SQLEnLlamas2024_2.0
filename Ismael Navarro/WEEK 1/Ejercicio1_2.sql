SELECT  
    c.customer_id,
    COUNT(DISTINCT s.order_date) AS total_visitas --no es necesario COALESCE porque COUNT ya devuelve valor 0 en lugar de NULL
FROM 
    case01.customers c
    LEFT JOIN case01.sales s
        ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id;
