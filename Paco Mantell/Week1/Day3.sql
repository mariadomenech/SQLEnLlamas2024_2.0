SELECT  DISTINCT A.customer_id,
  C.product_name
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
LEFT JOIN case01.menu C
	ON B.product_id = C.product_id
WHERE B.order_date = (SELECT MIN(order_date) FROM case01.sales);


/***************************************************/
/***************COMENTARIO DANI*********************/
/***************************************************/
/*
El resultado sería correcto, sin embargo habría un par de detallitos a mejorar.
Te animo a usar LISTAGG, o en este caso STRING_AGG (SQL Server) para que el resultado
nos liste al cliente A en la misma fila, separando su primer producto por una ",", por ejemplo.
También estaría bien enfocado listarnos al cliente D con un mensaje de "No ha hecho pedidos",
esto último no se pide como tal pero es una información que enriquece la query. 
Ánimo Paco, a por todas!*/
