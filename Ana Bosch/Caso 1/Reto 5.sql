-- RETO 5: ¿Cuántos puntos tendría cada cliente?

select customers.customer_id
	,coalesce(sum(case 
		when menu.product_id = 1 then menu.price * 20
		else menu.price * 10
	end), 0) as Puntos
from case01.customers customers
left join case01.sales sales
	on customers.customer_id = sales.customer_id
left join case01.menu menu
	on sales.product_id = menu.product_id
group by customers.customer_id
order by 2 desc

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Corectísimo. Nada que añadir en ningún apartado, este era más fácil incluso que el de ayer.
La semana que viene empieza lo divertido y tengo ganas de ver tus soluciones :)
Gracias por dedicarle tu tiempo y llevarlo al día, mucho ánimo con los siguientes y a disfrutarlo!!

*/
