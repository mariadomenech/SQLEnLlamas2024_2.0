SELECT C.CUSTOMER_ID, COALESCE(SUM(m.price), 0) AS TOTAL_GASTADO
FROM [case01].[customers] C
 LEFT JOIN [case01].[sales] S
	ON C.customer_id = S.customer_id
 LEFT JOIN [case01].[menu] M
	ON M.product_id = S.product_id
GROUP BY C.CUSTOMER_ID ;
