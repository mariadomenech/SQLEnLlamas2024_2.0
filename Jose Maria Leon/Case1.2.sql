Select C.customer_id,
Count (distinct s.order_date) as n_dias
from case01.customers C
	left outer join case01.sales S
	on C.customer_id=S.customer_id
group by C.customer_id
order by n_dias desc;