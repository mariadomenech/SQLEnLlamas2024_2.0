---------------------  Reto 2 ------------
/* Cuantos pedidos y cuantas pizzas se han entregado con exito por cada runner, Cual es el porcentaje de exito de cada runner que porcentaje de la pizzas tenía modificaciones.
   Todo debe mostrarse en una misma ventana de datos */



---- Ordeno y limpio
with Auxiliar as (
   select pedidos.order_id,pedidos.pizza_id,case 
                                                  when pedidos.exclusions in ('null',' ') and (pedidos.extras in ('null',' ') or pedidos.extras is null) then 'SinModificaciones'
												   else 'ConModificaciones'
                                            end as Modificaciones,
											case 
											      when (ped_runner.cancellation is null or ped_runner.cancellation in (' ','null')) then 'Entregado'
												   else 'Cancelado'
											  end as Estado_pedido,
											  ped_runner.runner_id as runner_id 
                                              from case02.customer_orders pedidos
              left join case02.runner_orders ped_runner on ped_runner.order_id=pedidos.order_id
),
----- Agrupamos los datos
Agrupacion as (
SELECT
   aux.runner_id  ,
    (select count(distinct order_id) from Auxiliar aux2 where aux2.runner_id=aux.runner_id ) as NumeroPedidos_Totales,
	(select count(distinct order_id) from Auxiliar aux2 where aux2.Estado_pedido='Entregado' and aux2.runner_id=aux.runner_id ) as NumeroPedidos_Entregados,
	(select count(*) from Auxiliar aux2 where aux2.Estado_pedido='Entregado' and aux2.Modificaciones='ConModificaciones' and aux2.runner_id=aux.runner_id  ) as Pizzas_Modificadas,
	(select count(*) from Auxiliar aux2 where aux2.Estado_pedido='Entregado' and aux2.Modificaciones='SinModificaciones' and aux2.runner_id=aux.runner_id  ) as Pizzas_SinModificar
FROM Auxiliar aux 
         GROUP BY aux.runner_id
)

--- Obtenemos el resultado

select runners.runner_id,
       isnull(agr.NumeroPedidos_Entregados,0) as PedidosEntregados,
	   case 
	       when agr.NumeroPedidos_Totales>0 then 
	       round(cast(agr.NumeroPedidos_Entregados as decimal(5,2))/cast(agr.NumeroPedidos_Totales as decimal(5,2))*100,2)
	      else 0.00
        end as Porcentaje_exito,
		isnull(agr.Pizzas_Modificadas,0) as PizzasConModificaciones,
		case 
	       when agr.Pizzas_Modificadas+agr.Pizzas_SinModificar>0 then 
	       round(cast(agr.Pizzas_Modificadas as decimal(5,2))/cast((agr.Pizzas_Modificadas+agr.Pizzas_SinModificar) as decimal(5,2))*100,2)
	      else 0.00
        end as Porcentaje_Modificadas

from case02.runners runners
                left join Agrupacion agr on agr.runner_id=runners.runner_id;
