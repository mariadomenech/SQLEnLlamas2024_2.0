select
c.customer_id, 
coalesce(count(distinct(order_date)),0) as Visitas
from case01.customers c
left join case01.sales s 
on c.customer_id=s.customer_id
group by c.customer_id
order by visitas desc;



/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado correcto!

Resultado: OK
Código: OK
Legibilidad: Para mejorar la legibilidad del código te aconsejo hacer tabulaciones. La legibilidad es un punto algo más subjetivo, pero hay que intentar que sea lo más fácil de leer posible.
              Te dejo como yo lo haría.

              select c.customer_id 
                    ,coalesce(count(distinct(order_date)),0) as Visitas
              from case01.customers c
              left join case01.sales s 
                    on c.customer_id=s.customer_id
              group by c.customer_id
              order by visitas desc;

*/
