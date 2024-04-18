/****** Cual es el producto más solicitado y el nº de veces solicitado ********/

select Ranking.Producto_mas_solicitado
      ,Ranking.Numero_solicitudes from ( select men.product_name as Producto_mas_solicitado,
                                                 count(*) as Numero_solicitudes,
												 RANK() OVER (ORDER BY count(*) DESC) as Rango
			                     from case01.sales sal
                                 inner join case01.menu men 
								 on sal.product_id=men.product_id
                                 group by men.product_name) as Ranking
where Ranking.Rango=1;
