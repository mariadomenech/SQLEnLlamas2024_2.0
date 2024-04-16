select c.customer_id, COUNT(distinct(s.order_date))
from (
	   (  case01.customers as c left join case01.sales as s on c.customer_id = s.customer_id ) 
	   ) 
group by c.customer_id;
