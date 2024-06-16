/* Crear una función en la que introduciendo categoría y segmento, muestre el producto más vendido de cada categoria, segmento*/

CREATE FUNCTION JLMG_Ejercicio4_4_ProductoTop (@segmento int, @categoria int)
  returns @Salida table (producto varchar(6) ,descripcion varchar(32),total_ventas decimal(15,2))
  AS

  Begin
      /* creammos una temporal para obtener el total de ventas por producto y ordenar por el de más ingresos*/

	  declare @TotalxProducto table (producto varchar(6) ,descripcion varchar(32),total_ventas decimal(15,2),Orden int)
	  insert into @TotalxProducto
							select ventas.prod_id,
								   prod.product_name,
								   sum(ventas.qty*ventas.price-ventas.discount) as total,
								   RANK() OVER ( ORDER BY sum(ventas.qty*ventas.price-ventas.discount) desc) as orden
								   from [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales] ventas 
										   inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details] prod on ventas.prod_id=prod.product_id
								   where prod.category_id=@categoria and prod.segment_id=@segmento
							group by ventas.prod_id,prod.product_name
						
		/*Cargamos en la salida los registros que tengan el ranking 1*/
		insert @Salida
		select producto,
			   descripcion,
			   total_ventas	  
			   from @TotalxProducto
			   where Orden=1
		return
end;
go;

/* Ejemplo */
select * from JLMG_Ejercicio4_4_ProductoTop (1,2)


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Perfecto!

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/
