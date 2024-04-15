Select c.customer_id, isnull(SUM(m.price),0) 
from (
	  ( case01.customers as c left join case01.sales as s on c.customer_id = s.customer_id )
							  left join case01.menu as m on m.product_id = s.product_id)
group by c.customer_id;
