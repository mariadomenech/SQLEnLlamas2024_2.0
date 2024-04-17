select	s.Cliente,
		string_agg(coalesce(s.product_name,'naica'),', ') as Papeo
from (
	select	distinct c.customer_id as Cliente
			, m.product_name
	from	case01.sales v
	inner join	(select	v.customer_id
						, min(v.order_date) as fecha_menor
				from	case01.sales v
				group by	v.customer_id) as w
		on	v.customer_id=w.customer_id
		and	v.order_date=w.fecha_menor
	left join	case01.menu m
		on	m.product_id=v.product_id
	right join	case01.customers c
		on c.customer_id=v.customer_id) s 
group by	Cliente
order by	1