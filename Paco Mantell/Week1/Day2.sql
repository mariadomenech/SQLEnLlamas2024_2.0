SELECT A.customer_id,
	ISNULL(COUNT(DISTINCT B.order_date), 0) visits
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
GROUP BY A.customer_id
ORDER BY 2 DESC;



/*******************************************/
/***********COMENTARIO DANI*****************/
/*******************************************/
/*Resultado correcto, buen uso de DISTINCT para evitar que nos aparezca el mismo día repetidas veces, 
muy buen uso de manejo de nulos. Buen enfoque al cruce de tablas. Te animo a que intentes buscar 
formas un poco mas complejillas para llegar a los mismos resultados, aún así muy buen trabajo!!*/
