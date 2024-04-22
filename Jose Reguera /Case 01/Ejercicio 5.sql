select AA.NombreCliente,
       Coalesce(Sum(AA.Num_puntos),0) as Puntos_totales 
from
(select c.customer_id as NombreCliente,
	   b.product_name NombreProducto,
	   b.price,
	   case when product_name ='sushi' then price*20 else price*10 end as Num_Puntos
	from  [case01].[sales] a
			 left outer join [case01].[menu] b
			  on a.product_id=b.product_id
			 right outer join [case01].[customers] c
			  on a.customer_id=c.customer_id	
	   
) AA

group by AA.NombreCliente
order by AA.NombreCliente asc
