select  a.customer_id as NombreCliente,
		count(distinct b.order_date) as	DiasVisitados	
from [case01].[customers] a
	    left outer join [case01].[sales] b
			on a.customer_id=b.customer_id
group by a.customer_id
order by 	DiasVisitados	desc

/*COMENTARIOS JUANPE*/
/*Solución, código y limpieza todo OK*/
