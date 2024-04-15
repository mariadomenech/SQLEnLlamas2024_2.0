-- CASO 1: Cuanto dinero han gastado los clientes
select customers.customer_id,
	isnull(sum(price),0) as sum_price
from case01.sales sales
right join case01.customers customers
	on sales.customer_id = customers.customer_id
left join case01.menu menu
	on sales.product_id = menu.product_id
group by customers.customer_id;
