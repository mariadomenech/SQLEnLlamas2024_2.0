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


/*********************************************************/
/***************** COMENTARIO ALEX *********************/
/*********************************************************/
/*

Una vez más está perfecto. La "chicha" estaba en pensar en situaciones en que no hubiera sólo una fila como
resultado y es justo lo que me comentas.

Como alternativa al RANK() podríamos usar TOP 1, y para contemplar casos de empate y que no
se perdieran filas de datos añadirle el parámetro WITH TIES (acompañado siempre de un ORDER BY) que, 
en caso de empate, te muestra todas las filas que lo componen. Como ejemplo de uso:

SELECT TOP 1 WITH TIES 
	product_name, 
	pedidos_totales
FROM (
	SELECT product_name, 
		COUNT(*) AS pedidos_totales
    FROM case01.sales sales
    JOIN case01.menu menu
		ON sales.product_id = menu.product_id
    GROUP BY product_name
) sub
ORDER BY pedidos_totales DESC;

Aún así creo que para clasificaciones es mejor usar el RANK como has hecho tú :)

*/
