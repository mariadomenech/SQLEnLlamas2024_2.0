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

Resultado OK!

Como consejo: El top 1 solo te va a devolver un único resultado o línea, ¿qué ocurre si existe empate entre dos productos en el número de veces que se han pedido? 
Haría uso de la función RANK(), por ejemplo, que si para una misma partición, dos valores son iguales al ordenarlos, tienen el mismo rango o número y 
nos permite sacar más de un producto en caso de empate.

Legibilidad: Ok.

*/
