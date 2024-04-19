select
	customer_id,
	sum(puntos_compra.puntos) as puntos_total
from(
	select 
		c.customer_id,
		case product_name
			when 'sushi' then price*2*10
			else  price*10
		end as Puntos
	from case01.customers c
	left join case01.sales s
	on c.customer_id=s.customer_id
	left join case01.menu m
	on s.product_id=m.product_id
) as puntos_compra
group by customer_id
