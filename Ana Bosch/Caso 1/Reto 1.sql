-- CASO 1: Cuanto dinero han gastado los clientes
select customers.customer_id,
	isnull(sum(price),0) as sum_price
from case01.sales sales
right join case01.customers customers
	on sales.customer_id = customers.customer_id
left join case01.menu menu
	on sales.product_id = menu.product_id
group by customers.customer_id;


/*
Comentarios Alex.
 
Resultado: Correcto
Código: Correcto
Legibilidad: Correcto

Todo perfecto, limpiando la salida para quitar los nulos y mostrando todos los clientes aunque no hicieran compra, además del uso de alias para las tablas.
Empezamos con un reto muy fácil pero ya se complicará jeje. Estoy seguro de que voy a aprender mucho más yo de ti que tu de mí y tengo ganas de ver los próximos retos.
A por el siguiente! :)
*/
