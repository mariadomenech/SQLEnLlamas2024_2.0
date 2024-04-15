select
	customers.customer_id,
	isnull(sum(menu.price), 0) as total_gastado
from
	case01.sales sales
join
	case01.menu menu
on
	(sales.product_id = menu.product_id)
right join 
	case01.customers customers
on
	(sales.customer_id = customers.customer_id)
group by
	customers.customer_id
order by
	customers.customer_id asc;
