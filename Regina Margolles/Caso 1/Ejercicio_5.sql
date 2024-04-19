Select 
         distinct(t2.customer_id),
	 SUM(ISNULL(t2.semi_total_points,0)) over (partition by t2.customer_id) as total_points
from
	(Select  t.customer_id,
		case when t.product_id = 1 then t.product_type_number*price*2*10 else t.product_type_number*price* 10 end as semi_total_points
	from   
		(Select 
			 c.customer_id,
			 COUNT(m.product_id) as product_type_number,
			 m.product_id,
			 m.product_name,
			 m.price
		from 
			case01.customers as c
			left join case01.sales as s 
			  on c.customer_id = s.customer_id
			left join case01.menu as m
			  on s.product_id = m.product_id
		group by c.customer_id, m.product_id, m.product_name, m.price
		 ) as t
		  )as t2;
