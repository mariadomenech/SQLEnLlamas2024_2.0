--SELECT TABLA PIZZAS MODIFICADAS--
/*Primero limpio la tabla de pizzas de customers. Añado un flag con las pizzas modificadas para hacer el cálculo más tarde.*/
select 
	co.order_id
	, case when (co.exclusions <> 'null' and co.exclusions <> ' ') or (co.extras <> 'null' and co.extras <> ' ' and co.extras <> 'NULL') then '1' else '0' end as flg_modificado
into #pizzasmodificadas
from case02.customer_orders co

select * from #pizzasmodificadas



--SELECT TABLAS UNIDAS sin filtrar--
/*En este paso se une la tabla anteriormente creada con la de pedidos de runners. Añadimos también un flag con los pedidos que se han entregado.*/
select
	ro.runner_id
	, ro.order_id
	, pz.flg_modificado
	, case when coalesce(ro.cancellation, 'a') not like '%Cance%' then '1' else '0' end as flg_entregado
into #totalpedidos
from case02.runner_orders ro
inner join #pizzasmodificadas pz
	on ro.order_id = pz.order_id
order by 1

select * from #totalpedidos



--QUERY DEFINITIVA--
/*En base a la tabla anterior, mediante selects podemos obtener lo que requería el ejercicio.*/
select
	ru.runner_id as Runner_malpagado
	, coalesce(count(distinct(case when tp.flg_entregado = 1 then tp.order_id else null end)),0) as Pedidos_completados
	, coalesce(sum(cast((tp.flg_entregado) as float)),0) Pizzas_entregadas	
	, case when count(distinct tp.order_id)=0 then 0 else (coalesce(count(distinct(case when tp.flg_entregado = 1 then tp.order_id else null end)),0)/cast(count(distinct tp.order_id) as float))*100 end as porc_Pedidos_completados
	, round(coalesce(((sum(cast(case when tp.flg_entregado = 1 then tp.flg_modificado else null end as float)))/(sum(cast((tp.flg_entregado) as float))))*100,0),2) as porc_Pizzas_modificadas
from #totalpedidos tp
right join case02.runners ru
	on ru.runner_id = tp.runner_id
group by ru.runner_id

/*
Corrección Pablo: ¡Todo perfecto!

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Como te comenté en el anterior ejercicio, a mí me gusta más el uso de CTEs, pero genial por usar tablas temporales y así evitar subconsultas.
Legibilidad: OK. ¡Mucho mejor estos últimos ejercicios con todo bien tabulado!
¡Enhorabuena!
*/
