SELECT 
	customer_id
	, ISNULL(STRING_AGG(product_name, ', ') WITHIN GROUP (ORDER BY product_name ASC), '') AS product_name
FROM (
	SELECT 
		DISTINCT M.product_name AS product_name
		, RANK() OVER
			(PARTITION BY C.customer_id ORDER BY S.order_date ASC) as rnk
		, C.customer_id AS customer_id
	FROM case01.sales S
	JOIN case01.menu M
		ON S.product_id = M.product_id
	RIGHT JOIN case01.customers C
		ON S.customer_id = C.customer_id
) a WHERE rnk = 1
GROUP BY customer_id;



/****************************************************/
/**************COMENTARIO DANIEL*********************/
/****************************************************/
/* Resultado correcto!, me gusta el enfoque de la subconsulta en vez de CTE´s, muy buena Elisa!. 
Sin embargo hay algunos detallitos que mejorar, el primero confío en que ha sido un error
accidental al indentar la línea tras el RANK() OVER..., el otro es mas importante y es sobre el 
cruce de tablas. En este caso estás partiendo de la tabla SALES, luego haces JOIN (= INNER JOIN)
a la tabla MENU y por ultimo desde SALES tambien haces RIGHT JOIN a la tabla CUSTOMERS. El apuntado
de SALES a CUSTOMERS está bien enfocado, sin embargo aunque en este caso te de el resultado esperado
si haces un FULL OUTER JOIN a una tabla con un volumen de datos considerable te dará problemas, el
enfoque correcto sería en este caso desde SALES usar LEFT JOIN a MENU y RIGHT JOIN a CUSTOMERS.

SELECT 
	customer_id
	, ISNULL(STRING_AGG(product_name, ', ') WITHIN GROUP (ORDER BY product_name ASC), '') AS product_name
FROM (
	SELECT 
		DISTINCT M.product_name AS product_name
		, RANK() OVER(PARTITION BY C.customer_id ORDER BY S.order_date ASC) as rnk
		, C.customer_id AS customer_id
	FROM SQL_EN_LLAMAS.case01.sales S
	LEFT JOIN SQL_EN_LLAMAS.case01.menu M
		ON S.product_id = M.product_id
	RIGHT JOIN SQL_EN_LLAMAS.case01.customers C
		ON S.customer_id = C.customer_id
) a WHERE rnk = 1
GROUP BY customer_id;


Ánimo Elisa, sé que puedes!*/
