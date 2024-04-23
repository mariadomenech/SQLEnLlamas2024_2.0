select
	ss.Producto
	, ss.Num_Ventas
from (select
		 ms.product_name as Producto
		 , count(vs.product_id) as Num_Ventas
	 from case01.sales vs
	 inner join case01.menu ms
		 on vs.product_id=ms.product_id
	 group by ms.product_name) ss
where ss.Num_Ventas=(select top 1 count(s.product_id)
					from case01.sales s
					group by s.product_id
					order by 1 desc)

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Resultado y código OK!

Legibilidad: Ok.

*/
