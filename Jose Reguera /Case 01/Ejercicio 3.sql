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

/*Comentarios Juanpe
El resultado y el codigo es correcto pero te comento un par de cosillas, es conveniente siempre hacer un control de nulos, un coalesce por ejemplpo y que te devuleta ' ' o 'Aun no ha hecho el primer pedido' en definitiva algo queno sea null.
En cuanto a la legibiilidad veo que dentro de la subelect tienes las columnas y luego mástubulado el from y los join, no está mal pero suele ser mejor si estan a la altura de la select, te pongo como lo haría yo (pero esto siempre digo lo mismo
no es algo único)
*/
select AA.NombreCliente,
       string_agg(AA.NombreProducto,',') as Producto
from (select distinct c.customer_id as NombreCliente,
                      b.product_name as NombreProducto,
                      a.order_date ,
                      rank() over (partition by c.customer_id order by order_date asc) as ranking
      from  [case01].[sales] a
      left  join [case01].[menu] b
              on a.product_id=b.product_id
      right join [case01].[customers] c
              on a.customer_id=c.customer_id        
     ) AA
where AA.ranking=1
group by AA.NombreCliente
/*Una cosa que quiero que veas aunque no es importante, la palabra "outer" en los cruces no son obligatorias un left = left outer (idem para right y full) no pasa nada por ponerla pero por si no lo sabías, a mi me gusta mas pues es una palabra menos en el
código, pero es cuestión de gustos.
*/
