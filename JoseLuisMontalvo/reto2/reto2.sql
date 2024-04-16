/***** Número de visitas por cliente *****/
select cust.customer_id as Cliente
      ,count(distinct sal.order_date) as N_Visitas
         from case01.customers cust
         left join case01.sales sal
	     on sal.customer_id=cust.customer_id
group by cust.customer_id;
