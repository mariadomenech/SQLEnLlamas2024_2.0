SELECT 
	product_name,
	time_ordered
FROM(
	SELECT 
		menu.product_name, 
		count(sales.product_id) as time_ordered,
		RANK()  over (order by count(sales.product_id) desc) as ranking
	FROM 
		case01.sales sales
	JOIN
		case01.menu menu
	ON
		(sales.product_id = menu.product_id)
	GROUP BY
		menu.product_name
) AS CONSULTA
WHERE ranking = 1;
/* También se podría hacer un select TOP 1 (ordenando por time_ordered desc) para sacar solo la primera fila, sin necesidad de hacer una subselect */
