select	clientes.customer_id cliente
		, count(distinct(ventas.order_date)) as dias_visitados
from	case01.sales ventas
right join	case01.customers clientes
	on	ventas.customer_id=clientes.customer_id
group by	clientes.customer_id
order by	1