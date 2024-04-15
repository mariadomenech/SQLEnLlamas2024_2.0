select	clientes.customer_id cliente,
		isnull(sum(price),0) as precio_total
from	case01.sales ventas
right join	case01.customers clientes
	on	ventas.customer_id=clientes.customer_id
left join	case01.menu precios
	on	precios.product_id=ventas.product_id
group by	clientes.customer_id
order by	clientes.customer_id asc			