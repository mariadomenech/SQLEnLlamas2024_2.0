SELECT C.CUSTOMER_ID, COALESCE(SUM(m.price), 0) AS TOTAL_GASTADO
FROM [case01].[customers] C
 LEFT JOIN [case01].[sales] S
	ON C.customer_id = S.customer_id
 LEFT JOIN [case01].[menu] M
	ON M.product_id = S.product_id
GROUP BY C.CUSTOMER_ID ;



/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*

Resultado: Correcto

Código: Correcto. Bien partiendo de la de customers para obtener a todos los clientes independientemente de si han comprado o no
y bien tratado el uso de los nulos usando COALESCE; son detalles que marcan la diferencia.

Legibilidad: Correcta. La legibilidad es muy subjetiva. Siendo correcta, se podría mejorar algún detalle. 
Por ejemplo: separando los campos del select es distintas filas.

SELECT 
	C.CUSTOMER_ID
      , COALESCE(SUM(m.price), 0) AS TOTAL_GASTADO
FROM [case01].[customers] C
LEFT JOIN [case01].[sales] S
       ON C.customer_id = S.customer_id
LEFT JOIN [case01].[menu] M
       ON M.product_id = S.product_id
GROUP BY C.CUSTOMER_ID ;

*/
