select
 c.customer_id,
 coalesce(sum(price),0) as total
from case01.customers c
left join case01.sales s
on c.customer_id=s.customer_id
left join case01.menu m
on s.product_id=m.product_id
group by c.customer_id ;
