select S.customer_id, sum(M.price) total_price
from [case01].[sales] S
join [case01].[menu] M
on S.product_id = M.product_id
group by S.customer_id;

/*****************************************/
/***********COMENTARIO DANIEL ************/
/* El resultado no está del todo correcto, no se contempla al cliente D y Josep quiere saber que dicho cliente no ha gastado nada o lo que es lo mismo,
ha gastado 0. 
También te animo a mejorar un poco la legibilidad del código, algo así:

SELECT  S.customer_id,
        SUM(M.price) AS total_price
FROM case01.sales S
JOIN case01.menu M
      ON S.product_id = M.product_id
GROUP BY S.customer_id

Solo faltaría implementar al cliente que falta, ten en cuenta que también hay que unir bien las tablas, confío en que podrás!.
Para tratar campos nulos puedes probar IFNULL(), NVL(), aunque en SQLServer (donde estamos haciendo los ejercicios) se usaría ISNULL() por ejemplo ya que Josep en este caso quiere ver un 0 y no NULL en el campo
A mí personalmente me gusta poner los agregados y funciones en Mayusc. y los atributos en minusc, ya que mejora la legibilidad
pero eso es gusto propio. Ánimo Elisa que seguro lo consigues!. Intenta plasmas la corrección bajo este comentario. Cualquier duda me tienes a tu disposición*/

/********************** CORRECCION *********************/
-- Muchas gracias por los comentarios! :)

SELECT  C.customer_id,
	ISNULL(SUM(M.price),0) AS total_price
FROM case01.sales S
JOIN case01.menu M
	ON S.product_id = M.product_id
RIGHT JOIN case01.customers C
	ON S.customer_id = C.customer_id
GROUP BY C.customer_id;
