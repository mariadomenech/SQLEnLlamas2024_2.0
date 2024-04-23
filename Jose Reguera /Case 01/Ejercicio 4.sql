select AA.NombreProducto,
	   AA.Ranking_conteo,
	   AA.Num_veces_pedido

from 
	  (select  b.product_name as NombreProducto,
	   rank() over (order by count(a.product_id)  desc) as Ranking_conteo,
	   count(a.product_id) Num_veces_pedido
	   from [case01].sales a 
	    left outer join [case01].[menu] b
		 on a.product_id=b.product_id
		
	
	 group by b.product_name
	 ) AA
	 where AA.Ranking_conteo=1
/*COMENTARIOS JUANPE

TODO CORRECTO. Aunque si me aceptas un consejo no es recomendable dejar saltos de linea en el código*/
