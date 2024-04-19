-- RETO 3
-- ¿Cúal es el primer producto que ha pedido cada cliente?

SELECT DISTINCT A.customer_id Cliente, COALESCE(A.product_name,'') Primer_pedido
FROM (
	SELECT C.customer_id, B.product_name,
			RANK() OVER (PARTITION BY A.customer_id ORDER BY A.order_date ASC) AS rank
	FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales A
	LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu B ON (A.product_id = B.product_id)
	RIGHT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.customers C ON (A.customer_id = C.customer_id)
	) A
WHERE A.rank= 1;


/*****************************************/
/*******COMENTARIO DANI*******************/
/*****************************************/
/* Resultado ligeramente correcto, me explico, los resultados obtenidos
no difieren de lo que se pide, pero habría algunos puntos a mejorar.
En la consulta se nos devuelve dos filas para el cliente A ya que pidió en
el mismo pedido sushi y curry, lo ideal sería tenerlo en la misma línea, te
animo a que indagues acerca de la función STRING_AGG y WITHIN GROUP ya que 
te permiten concatenar diferentes resultados en una sola fila separada por lo
que tu establezcas, ya sea una coma, una barra, etc.
También te recomiendo intentar usar CTE en vez de subconsulta, las CTE´s nos 
ofrecen muchas funcionalidades y ventajas, verás que interesante!. 
Por último te recomiendo mejorar la legibilidad del código, intenta indentar
cada atributo a seleccionar y en diferentes filas, en vez de :

SELECT C.customer_id, B.product_name,

prueba a:

SELECT	C.customer_id
,	B.product_name


de esta forma mejoramos la interpretación del código. Ánimo Felipe, sé que 
puedes!*/
