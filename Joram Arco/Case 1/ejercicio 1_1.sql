select
	customers.customer_id as cliente,
	isnull(sum(menu.price), 0) as importe_total
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
