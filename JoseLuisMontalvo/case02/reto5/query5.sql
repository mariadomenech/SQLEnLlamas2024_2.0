/* Cuantas veces ha sido usado cada ingrediente sobre el total de pizzas entregadas con exito, ordenado de mas a menos frecuente*/

 declare @ingredientes_aux table (id int,nombre varchar(50),n_usado int)
 insert into @ingredientes_aux select pt.topping_id,pt.topping_name,0 from case02.pizza_toppings pt
 
declare @pedido int
declare @pizza int
declare @ingredientes_base varchar(50)
declare @ingredientes_extra varchar(50)
declare @ingredientes_excluidos varchar(50)

	
--- Nos recorremos todos los pedidos que han sido entregados y extraemos los ingredientes base, extras y excluidos de cada uno de ellos

declare cur_ingredientes cursor for 
                                select pedidos.order_id,pedidos.pizza_id, p_rec.toppings as base,pedidos.extras,pedidos.exclusions 
									                     from case02.customer_orders pedidos
                                             inner join case02.runner_orders ped_runner on ped_runner.order_id=pedidos.order_id 
			                                                                       and  (ped_runner.cancellation is null or ped_runner.cancellation in (' ','null')) 
			                                       inner join case02.pizza_recipes p_rec on p_rec.pizza_id=pedidos.pizza_id
	open cur_ingredientes
	fetch next from cur_ingredientes into @pedido,@pizza,@ingredientes_base,@ingredientes_extra,@ingredientes_excluidos

	while @@FETCH_STATUS = 0
			begin
			 
			   -- Por cada ingrediente base, añadimos uno al numero de veces usado en la tabla auxiliar de ingredientes
	       update @ingredientes_aux  set n_usado=n_usado+1 
                from string_split(@ingredientes_base,',') as ingrediente
				       inner join @ingredientes_aux as ing_aux on ( ing_aux.id=try_cast(ingrediente.value as int) or ing_aux.nombre=try_cast(ingrediente.value as varchar))

			   if @ingredientes_extra not in ('null',' ')
			     begin 
			       -- Por cada ingrediente extra, añadimos uno al numero de veces usado en la tabla auxiliar de ingredientes
			     update @ingredientes_aux  set n_usado=n_usado+1  from string_split(@ingredientes_extra,',') as ingrediente_extra
				       inner join @ingredientes_aux as ing_aux on ( ing_aux.id=try_cast(ingrediente_extra.value as int) or ing_aux.nombre=try_cast(ingrediente_extra.value as varchar))
			     end
               if @ingredientes_excluidos not in ('null',' ') 
			      begin
				    -- Por cada ingrediente excluido, restamos uno al numero de veces usado en la tabla auxiliar de ingredientes
				  update @ingredientes_aux  set n_usado=n_usado-1  from string_split(@ingredientes_excluidos,',') as ingrediente_excluido
				       inner join @ingredientes_aux as ing_aux on ( ing_aux.id=try_cast(ingrediente_excluido.value as int) or ing_aux.nombre=try_cast(ingrediente_excluido.value as varchar))
			      end			   				  
				 fetch next from cur_ingredientes into @pedido,@pizza,@ingredientes_base,@ingredientes_extra,@ingredientes_excluidos
			end 
close cur_ingredientes
deallocate cur_ingredientes

--- Resultado final
select ing.id as iD,
       ing.nombre as Ingrediente, 
	   ing.n_usado as Usado 
from @ingredientes_aux ing
order by ing.n_usado desc ;
