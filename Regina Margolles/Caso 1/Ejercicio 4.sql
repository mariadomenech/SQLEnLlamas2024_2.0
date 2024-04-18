select top (1)  m.product_name as nombre_producto,
               (COUNT(s.product_id)) as numero_veces_pedido
from case01.sales as s 
			 left join case01.menu as m 
			    on s.product_id = m.product_id
group by s.product_id, m.product_name 
order by COUNT(m.product_id) desc;
