select 
	distinct a.cliente
	,coalesce(a.producto, 'Sin Pedidos') as producto
from
	(
	select 
		cli.customer_id as cliente
		, b.product_name as producto
		-- nos quedamos con la fecha de primer pedido, y añadimos product_id en la ordenación por haber varios para un mismo cliente en la misma fecha
		,RANK() OVER (PARTITION BY a.customer_id ORDER BY a.order_date asc, a.product_id asc) primero
	from 
		case01.customers cli
		left join [case01].[sales] a
			on a.customer_id = cli.customer_id	
		left join case01.menu b
			on a.product_id = b.product_id
	)a
where 
	primero = 1
order by 
	a.cliente;

/*COMENTARIOS JUANJPE
Incorrecto en el caso del A se buscaba los dos platos, que pidio en el primer pedido, pues la pregunta era cual es primer "producto" y dentro de cada pedido no hay información para decir cual de los dos se pidió primero.
Realmente te has dado cuenta pero has decidido sacar solo 1. La idea del ejercio era sacar todos y luego dejar una fila por cliente con la función STRING_AGG.*/
