SELECT	C.customer_id, 
		    COUNT(DISTINCT(order_date)) num_dias
FROM case01.sales S
RIGHT JOIN case01.customers C
  ON S.customer_id = C.customer_id
GROUP BY C.customer_id;
