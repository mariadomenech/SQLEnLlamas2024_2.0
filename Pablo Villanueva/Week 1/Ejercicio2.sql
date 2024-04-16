SELECT  C.customer_id,
  COUNT   ( DISTINCT Order_date) as  TOTAL_VISITAS
FROM case01.customers C
LEFT JOIN case01.sales S
	ON C.customer_id = S.customer_id
GROUP BY C.customer_id 
;
