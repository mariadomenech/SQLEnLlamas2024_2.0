/** Total gastado por cada cliente**/
SELECT A.customer_id,
  ISNULL(SUM(C.price), 0) total
FROM case01.customers A
LEFT JOIN case01.sales B
	ON A.customer_id = B.customer_id
LEFT JOIN case01.menu C
	ON B.product_id = C.product_id
GROUP BY A.customer_id;


/************************************************/
/***************COMENTARIO DANIEL****************/
/*Resultado correcto, buen uso de LEFT JOINS para un correcto cruce de tablas, bien contemplado el caso de que el resultado sea NULL. Como pequeño consejo 
te diría de indentar mejor los atributos que seleccionamos para que se pueda leer mas fácilmente */
