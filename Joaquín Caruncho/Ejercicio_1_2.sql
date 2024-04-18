select 
	a.customer_id AS CLIENTE
	, count(distinct order_date) AS DIAS_VISITADO
from 
	case01.customers a
	left join case01.sales b
		on a.customer_id = b.customer_id
GROUP BY a.customer_id
order by a.customer_id;
