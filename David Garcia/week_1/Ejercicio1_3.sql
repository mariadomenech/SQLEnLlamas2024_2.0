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

/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado correcto, enhorabuena!!

Resultado: OK
Código: OK
Legibilidad: Podría mejorarse un poco la parte del SELECT dentro del FROM para que se pueda leer mejor. Te dejo como lo haría yo: 
				select
					compras.customer_id as cliente,
					string_agg(coalesce((product_name), 'Sin pedido'),',') as productos
				from(
					 select
					 	distinct c.customer_id,
						product_name,
					 	RANK() OVER (PARTITION BY c.customer_id ORDER BY s.order_date asc) AS fechas_rank,
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

Un par de detalles que me han gustado mucho es la utilización de STRING_AGG para hacer la salida de la query más limpia y de RANK para que muestre si hay empates entre productos.

*/
