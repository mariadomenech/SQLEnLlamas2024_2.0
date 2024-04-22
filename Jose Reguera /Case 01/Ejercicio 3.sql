select AA.NombreCliente,
	   string_agg(AA.NombreProducto,',') as Producto
from  
(select distinct c.customer_id as NombreCliente,
		 b.product_name as NombreProducto,
		 a.order_date ,
		 rank() over (partition by c.customer_id order by order_date asc) as ranking
			from  [case01].[sales] a
			 left outer join [case01].[menu] b
			  on a.product_id=b.product_id
			 right outer join [case01].[customers] c
			  on a.customer_id=c.customer_id		
) AA
where AA.ranking=1
group by AA.NombreCliente
