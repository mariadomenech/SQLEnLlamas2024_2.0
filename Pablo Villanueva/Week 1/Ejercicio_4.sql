SELECT 
	TOP 1
   PRODUCT_NAME,
	 COUNT(S.PRODUCT_ID) AS TOTAL_PEDIDO    
FROM 
    [case01].[sales] s 
LEFT JOIN 
    [case01].[menu] m ON s.product_id = m.product_id
GROUP BY
    m.product_name
ORDER BY
	COUNT(S.PRODUCT_ID) DESC;
