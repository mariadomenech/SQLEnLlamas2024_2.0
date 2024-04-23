
select 
	b.producto
	,b.numero_pedidos
from
	(
	select
		a.producto
		, numero_pedidos
		,RANK()  over (order by a.numero_pedidos desc) as mas_pedido
	from
		(

		select 
			 b.product_name as producto
			,COUNT(*) as numero_pedidos

		from
			[case01].[sales] a
			left join case01.menu b
				on a.product_id = b.product_id
		group by b.product_name
		)a

	)b
	where 
		b.mas_pedido = 1
/*COMENTARIOS JUANPE
Todo correcto aunque si me admites un consejo, no es recomendable en el código dejar saltos de lineas*/


