SELECT  DISTINCT A.customer_id,
  C.product_name
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
LEFT JOIN case01.menu C
	ON B.product_id = C.product_id
WHERE B.order_date = (SELECT MIN(order_date) FROM case01.sales);
