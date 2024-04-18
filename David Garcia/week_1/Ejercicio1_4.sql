select 
	  TOP 1
	  product_name,
	  sum((veces_x_dia)) as total_x_product
from(  
		select 
			  product_name,
			  count(product_name) as veces_x_dia,
			  order_date
		from case01.sales s
		left join case01.menu m
		on s.product_id=m.product_id
		group by product_name,order_date
	  ) as conteo 
group by product_name
order by total_x_product desc;
