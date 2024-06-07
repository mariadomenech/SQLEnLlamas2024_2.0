select top (1)  m.product_name as nombre_producto,
               (COUNT(s.product_id)) as numero_veces_pedido
from case01.sales as s 
			 left join case01.menu as m 
			    on s.product_id = m.product_id
group by s.product_id, m.product_name 
order by COUNT(m.product_id) desc;



/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/

/* 

Perfecto Regina! 
Las tabulaciones las cambiaría por lo que te he comnetado en los ejericios 1 y 2 de legibilidad.

Como consejo: El top 1 solo te va a devolver un único resultado o línea, ¿qué ocurre si existe empate en el número de veces pedido dos productos? 
Habría que usar la función RANK(), que si para una misma partición, dos valores son iguales al ordenarlos, tienen el mismo rango o número y 
nos permite sacar más de un producto en caso de empate.

*/

/*********************************************************/
/***************** CORRECIÓN *********************/
/*********************************************************/

select nombre_producto,
       numero_veces_pedido
from
	(select  nombre_producto,
		 numero_veces_pedido,
	         RANK() over (order by numero_veces_pedido desc) as ranking
	 from(
		select   m.product_name as nombre_producto,
			 COUNT(s.product_id) as numero_veces_pedido
		 
		from case01.sales as s 
		left join case01.menu as m 
		 on s.product_id = m.product_id
		group by s.product_id, m.product_name 
		)as t
	) as t2
where ranking = 1;
