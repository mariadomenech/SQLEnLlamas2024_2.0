-- RETO 4: Cuál es el producto más pedido del menú y cuántas veces ha sido pedido?

select ranking.mas_pedido
	,ranking.veces_pedido
from (
	select product_name as mas_pedido
		,count(product_name) as veces_pedido
		,rank() over (order by count(product_name) desc) as rank 
	from case01.sales sales
	join case01.menu menu
		on sales.product_id = menu.product_id
	group by product_name
) ranking
where rank = 1
order by 1 asc

/* Esta solución tiene en cuenta los casos en los que varios productos tengan el mismo número de pedidos, 
permitiendo que salgan como resultado de la consulta todos ellos. Teniendo en cuenta esos casos, se ordena
la consulta por nombre de producto */
