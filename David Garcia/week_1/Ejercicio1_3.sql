select
	compras.customer_id as cliente,
	string_agg(coalesce((product_name), 'Sin pedido'),',') as productos
from(
	 select
	 distinct c.customer_id,
	 product_name,
	 RANK() OVER (PARTITION BY c.customer_id ORDER BY s.order_date asc)
	 AS fechas_rank,
	 s.order_date
	 from case01.customers c
	 left join case01.sales s
		on c.customer_id=s.customer_id
	 left join case01.menu m
		on s.product_id=m.product_id

	) as compras
where fechas_rank=1
group by compras.customer_id
order by 1

