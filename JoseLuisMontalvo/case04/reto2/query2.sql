declare @productos table (product_id varchar(6),product_name varchar(32),Orden int) 

/* Cargamos en una tabla temporal los productos y le damos un código númerico a cada uno para luego agrupar*/
insert into @productos 
		 SELECT [product_id]
			  ,[product_name]
			  ,row_number() over( order by [product_id] ) as Orden
		 FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_details] 


/*Creamos una tabla temporal para guardar las distintas combinaciones de 12 productos, tomados de 3 en 3.*/
declare @combinaciones table (combinacion int,Producto1 varchar(6),Descripcion1 varchar(32),
                                              Producto2 varchar(6),Descripcion2 varchar(32),
											  Producto3 varchar(6),Descripcion3 varchar(32),
							   repeticiones int )
/*insertamos las distintas combinaciones posibles en la temporal*/
insert into @combinaciones 
				  select row_number() over( order by p1.orden,p2.orden,p3.orden ) as combinacion,
						 p1.product_id as Producto1,
						 p1.product_name as Descripcion1,
						 p2.product_id as Producto2,
						 p2.product_name as Descripcion2,
						 p3.product_id as Producto3,						
						 p3.product_name as Descripcion3,
						 0 as repeticiones
					 from @productos p1 
						inner join @productos p2 on p1.orden<p2.orden
						inner join @productos p3 on p2.orden<p3.orden

declare @producto1_aux varchar(6)
declare @producto2_aux varchar(6)
declare @producto3_aux varchar(6)
declare @repeticiones_aux int

/* Recorremos mediante un cursor todas la combinaciones posibles y buscamos en la tabla de venta en cuantas transacciones están, almacenamos el conteo en la tabla de combinaciones*/
declare cur cursor for select Producto1,Producto2,Producto3 from @combinaciones

		open cur
			fetch next from cur into @producto1_aux,@producto2_aux,@producto3_aux

		while @@FETCH_STATUS = 0
		begin
			   select @repeticiones_aux=COUNT(distinct sal1.txn_id) from  [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales] sal1 
										  inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales] sal2 on sal1.txn_id=sal2.txn_id and sal2.prod_id=@producto2_aux
										  inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales] sal3 on sal1.txn_id=sal3.txn_id and sal3.prod_id=@producto3_aux
										  where sal1.prod_id=@producto1_aux 
				if @repeticiones_aux>0
				begin
						update @combinaciones set repeticiones=@repeticiones_aux where Producto1=@producto1_aux and Producto2=@producto2_aux and Producto3=@producto3_aux

				end 

			fetch next from cur into @producto1_aux,@producto2_aux,@producto3_aux
		end

close cur
deallocate cur

/*Finalmente obtenemos el resultado y nos quedamos nos las combinaciones que tienen el mayor numero de repeticiones*/

select Descripcion1 as Producto_1,
       Descripcion2 as Producto_2,
	   Descripcion3 as Producto_3,
	   repeticiones as Numero_txn_distintas
from @combinaciones com 
     where repeticiones in (Select MAX(repeticiones) from @combinaciones)


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Poco se puede comentar, solución muy original y de un nivel muy avanzado.

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/
               
