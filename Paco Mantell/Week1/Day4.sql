SELECT TOP 1 A.product_name,
COUNT(B.product_id) times_ordered
FROM case01.menu A
LEFT JOIN case01.sales B
	ON A.product_id=B.product_id
GROUP BY A.product_name
ORDER BY times_ordered DESC;



/*****************************************/
/*******COMENTARIO DANI*******************/
/*****************************************/
/*
Resultado correcto, indentaría un poco mas los atributos para mejorar
la legibilidad. Te animo a que busques métodos algo mas complejos o 
técnicos para llegar al mismo resultado, por ejemplo el uso de una 
función de ventana RANK, o WITH TIES (ojo con esta que tiene truco)
Ánimo Paco, sé que puedes!*/
