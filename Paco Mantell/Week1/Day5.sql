SELECT customer_id,
	SUM(points) total_points
FROM
(SELECT A.customer_id,
	ISNULL(C.product_name, 'Nada') product,
	CASE WHEN C.product_name='shushi' THEN
		COUNT(B.product_id) * 20
	ELSE
		COUNT(B.product_id) * 20
	END points
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id=B.customer_id
LEFT JOIN case01.menu C
	ON B.product_id=C.product_id
GROUP BY A.customer_id, C.product_name) A
GROUP BY customer_id
ORDER BY total_points DESC


/*************************************/
/*********COMENTARIO DANI*************/
/*************************************/
/*Resultado incorrecto, el sushi como producto otorga el doble de puntos
que el resto, para calcular dichos puntos tenemos que tener en cuenta que
cada euro gastado equivale a diez puntos (por ahí ya tenemos indicadores) y
luego en el caso del sushi esos puntos se duplican. En tus resultados 
obtenemos unas cifras mas bajas de lo esperado, además tanto el cliente 
A como B tienen ambos los mismos puntos, así como chivatillo te digo
que tienen cifras distintas. Te animo a que le des un par de vueltas y me 
pongas la corrección mas abajo de este comentario, además también te animo 
a que lo intentes hacer usando una CTE en vez de subconsulta, al final
las CTE nos dan muchísimas ventajas frente a las subconsultas. Ánimo Paco, sé 
que puedes con esto y con mucho mas! a por todas!!*/
