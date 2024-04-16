-- ¿Cuántos días ha visitado el restaurante cada cliente?

select clientes.customer_id
	,count(distinct order_date) as visitas
from case01.customers clientes
left join case01.sales pedidos
	on clientes.customer_id = pedidos.customer_id
group by clientes.customer_id
order by 2 desc;
