select
c.customer_id, 
coalesce(count(distinct(order_date)),0) as Visitas
from case01.customers c
left join case01.sales s 
on c.customer_id=s.customer_id
group by c.customer_id
order by visitas desc;
