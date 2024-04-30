/* Partiendo de la receta de cada una de las pizzas de tabla, pizzas_recipiet_spli, cuantas veces se repite cada topping/ingrediente si la pizza
meatlover y la vegetariana llevan queso , el ingrediente se repite 2 veces*/

declare @top1 int
declare @top2 int
declare @top3 int
declare @top4 int
declare @top5 int
declare @top6 int
declare @top7 int
declare @top8 int

declare @topping_id int
declare @topping_name  varchar(30)

declare @tabla_salida table (Repetido int , topping varchar(20))  --- Tabla auxiliar para almacenar el resultado

     declare cur_top cursor for select topping_id,topping_name from case02.pizza_toppings  --- Nos recorremos todos los ingredientes y vamos buscando si estan o no en las pizzas     
		open cur_top
		fetch next from cur_top into @topping_id,@topping_name 

		while @@FETCH_STATUS = 0
			begin
					declare cur_pizza cursor for select topping_1, topping_2,topping_3,topping_4,topping_5,topping_6,topping_7,topping_8  from case02.pizza_recipes_split pizza_splt 
					open cur_pizza 
					fetch next from cur_pizza into @top1,@top2,@top3,@top4,@top5,@top6,@top7,@top8

								while @@FETCH_STATUS = 0
								begin      
												  if @top1=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top2=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top3=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top4=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top5=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top6=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top7=@topping_id  insert into @tabla_salida values(1,@topping_name)
												  if @top8=@topping_id  insert into @tabla_salida values(1,@topping_name)


							         fetch next from cur_pizza into @top1,@top2,@top3,@top4,@top5,@top6,@top7,@top8
							      end
					close cur_pizza
					deallocate cur_pizza
													   
				fetch next from cur_top into @topping_id,@topping_name
			end
		 close cur_top
		 deallocate cur_top

		--- Tenemos una tabla con los ingredientes que hay en las pizzas, ahora los agrupamos y vemos los que se repiten.
	select topping,count(*) as Repetido from @tabla_salida
	group by topping
	order by 2 desc;

