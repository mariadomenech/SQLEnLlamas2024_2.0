select 
  cust.customer_id as Cliente,
  count(distinct sales.order_date) as Num_visitas
from case01.sales sales
right join case01.customers cust
  on sales.customer_id = cust.customer_id
group by cust.customer_id
order by Num_visitas desc;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

Perfecto Jose!!!

*/
