SELECT TOP 1 
 menu.product_name AS "Producto más pedido",
        
 
 COUNT(*) AS "Veces pedido"
FROM 
 case01.sales sales
JOIN 
 case01.menu menu
ON 
 sales.product_id = menu.product_id
GROUP BY 
 menu.product_name
ORDER BY 
 COUNT(*) DESC;
