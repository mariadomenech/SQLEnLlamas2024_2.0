SELECT 
    c.CUSTOMER_ID, 
    COALESCE(SUM(m.PRICE), 0) AS TotalGastado
FROM 
    case01.customers c
LEFT JOIN 
    case01.sales s ON c.CUSTOMER_ID = s.CUSTOMER_ID
LEFT JOIN 
    case01.menu m ON s.PRODUCT_ID = m.PRODUCT_ID
GROUP BY 
    c.CUSTOMER_ID;