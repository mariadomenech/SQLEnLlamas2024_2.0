/* una pizza meat lovers cuesta 12€ y una vegetarina 10, y cada ingrediente extra supone 1€ adicional
   Por otro lado a cada corredor se le paga 0,30€/km ¿Cuanto dinero le sobra a Guisepe)*/
  

 ---- Calculamos la distancia recorrida por cada repartidor/pedido y el precio que cobra por ello.
with Auxiliar_runner as (
select runner_id,order_id,sum(
                      case 
                      when TRY_CAST(distance as decimal(10,2)) is null then cast(substring(distance,patindex('%[0-9.]%',distance),patindex('%[^0-9.]%',distance)-1) as decimal(10,2))
                      else TRY_CAST(distance as decimal(10,2))
                      end) as Distancia_Recorrida,
					  sum(
                      case 
                      when TRY_CAST(distance as decimal(10,2)) is null then cast(substring(distance,patindex('%[0-9.]%',distance),patindex('%[^0-9.]%',distance)-1) as decimal(10,2))
                      else TRY_CAST(distance as decimal(10,2))
                      end) *.30 as Coste_recorrido ---- Importe_a_pagar, 0,30 por km ---
			from case02.runner_orders 
			where distance<>'null'
group by runner_id,order_id ) ,
------ Ponemos una tabla auxiliar para facilitar porner los precios de las pizzas y otros cambios
Auxiliar_precios as(
select pizza_id,pizza_name,
                            case when pizza_id=1 then 12
							     when pizza_id=2 then 10
								 else 0
								 end as precio,
								 1 as pvp_ing_extra
					 from case02.pizza_names
 ),
 ---- Calculamos el precio de cada pedido
Auxiliar_pedidos as(
   select pedidos.order_id,aux_pvp.precio,
						 case when patindex('%[0-9,]%',extras)>0 
						            then (LEN(extras) - LEN(REPLACE(extras, ',', '')) + 1)*aux_pvp.pvp_ing_extra
	                      else 0 end AS precio_extra,
 						case 
											      when (ped_runner.cancellation is null or ped_runner.cancellation in (' ','null')) then 'Entregado'
												   else 'Cancelado'
											  end as Estado_pedido,
											  ped_runner.runner_id as runner_id 
                                              from case02.customer_orders pedidos
              left join case02.runner_orders ped_runner on ped_runner.order_id=pedidos.order_id
			  left join Auxiliar_precios aux_pvp on aux_pvp.pizza_id=pedidos.pizza_id  ),


----- Obtenermos resultado por pedido		
Aux_resultado as (
select order_id,
      sum(precio) as Imp_pizzas,
	  sum(precio_extra) as Imp_extras,
      (select Coste_recorrido from Auxiliar_runner aux_run where aux_run.order_id=aux_ped.order_id) as Costes_runner,
      sum(precio+precio_extra)-(select Coste_recorrido from Auxiliar_runner aux_run where aux_run.order_id=aux_ped.order_id) as Resto
from Auxiliar_pedidos aux_ped
where aux_ped.Estado_pedido='Entregado'
group by order_id)

--- Resultado final
select sum(Imp_pizzas) as Imp_Pizzas,
       sum(Imp_extras) Imp_extras,
	   sum(Costes_runner) Costes_runner 
from Aux_resultado ;
