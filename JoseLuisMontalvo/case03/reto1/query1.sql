/* Reto 1 
  En Cuántos días de media se reasignan los clientes a un nodo diferente*/
declare @customer_id int
declare @node_id int 
declare @inicio date
declare @fin date
declare @customer_id_aux int
declare @node_id_aux int 
declare @inicio_aux date
declare @fin_aux date
declare @customer_changes table (cus int,nodo int,inicio date,fin date ,dias int)
set @customer_id_aux=0
set @node_id_aux=0

--- Nos recorremos la signación de nodos por cada cliente ordenada por fecha de inicio de asignación, cada vez que cambiamos de nodo, calculamos la diferencia en días de inicio hasta fin.
  declare cur cursor for 
                       select customer_id,node_id,start_date,end_date from case03.customer_nodes
                       order by customer_id,start_date
  open cur
  fetch next from cur into @customer_id,@node_id,@inicio,@fin

		while @@FETCH_STATUS = 0
			begin
				  if @customer_id<>@customer_id_aux
					   begin
						 if @node_id<>@node_id_aux
						   begin
							 insert into @customer_changes values (@customer_id,@node_id,@inicio,@fin,datediff(day,@inicio,@fin))
						   end
				      end
					  else
					      begin
								  if @node_id<>@node_id_aux
							   begin
								 insert into @customer_changes values (@customer_id,@node_id,@inicio,@fin,datediff(day,@inicio,@fin))
							   end
							   else
							   begin
							     	update @customer_changes set fin=@fin,dias=datediff(day,inicio,@fin)  where cus=@customer_id and nodo=@node_id and inicio=@inicio_aux
							   end 
						  end 

	       set @customer_id_aux=@customer_id
		   set @node_id_aux=@node_id
		   set @inicio_aux=@inicio
		      
		fetch next from cur into @customer_id,@node_id,@inicio,@fin
		end
close cur
deallocate cur

--- Calculamos la media por cada cliente
select cast(avg(dias) as decimal(10,2)) as Media_dias_cambio_nodo from @customer_changes where fin<>'9999-12-31' 
