-- RETO 3: ¿Cuál es el primer producto que ha pedido cada cliente?

select subselect.customer_id as cliente
	,string_agg(coalesce(product_name, 'Sin pedido'), ', ') as pedido
from (
	select distinct customers.customer_id
		,order_date
		,product_name
		,RANK() OVER (PARTITION BY customers.customer_id ORDER BY order_date asc) AS rank
	FROM case01.customers customers
	left join case01.sales sales
		on customers.customer_id = sales.customer_id
	left join case01.menu menu
		on sales.product_id = menu.product_id
) as subselect
where rank = 1
group by subselect.customer_id
order by 1

/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Está perfecto, la idea del ejercicio era usar un RANK O DENSE_RANK y el STRING_AGG mas el tratamiento de los nulos y lo has tenido en cuenta
así que genial.

Personalmente prefiero las CTEs a las subconsultas, pero es algo totalmente subjetivo y, en casos sencillos como este, la legibilidad
es la misma.

*/
