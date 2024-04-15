select 
	a.customer_id AS CLIENTE
	, sum(coalesce(c.price,0)) AS GASTO
from 
	case01.customers a
	left join case01.sales b
		on a.customer_id = b.customer_id
	left join case01.menu c
		on b.product_id = c.product_id
group by a.customer_id
order by a.customer_id;
