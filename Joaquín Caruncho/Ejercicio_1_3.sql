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
