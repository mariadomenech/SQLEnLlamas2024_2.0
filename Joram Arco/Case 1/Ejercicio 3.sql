SELECT
	cliente,
	COALESCE(STRING_AGG(product_name, ','),' ') as productos --COALESCE(STRING_AGG(product_name, ','),'Sin pedido') para sacar un literal que indique que no tiene pedidos en lugar de vacio
FROM (
	SELECT
		DISTINCT customers.customer_id as cliente,
		menu.product_name,
		sales.order_date,
		RANK() OVER(PARTITION BY customers.customer_id ORDER BY sales.order_date) as ranking
	FROM
		case01.customers customers
	LEFT JOIN
		case01.sales sales
	ON
		(customers.customer_id = sales.customer_id)
	LEFT JOIN
		case01.menu
	ON
		(sales.product_id = menu.product_id)
) as CONSULTA
WHERE
	ranking = 1
GROUP BY 
	cliente
ORDER BY
	cliente ASC
/*COMENTARIOS JUANPE
TODO CORRECTO. El nulo siempre es bueno limpiarlo con algun valor por defecto aunque sean ' ' asique igual de correcto ' ' , 'sin pedido', la gracia es no dejar null. Otras ideas para que te sirva en futuros ejercicios, los resultados se pueden mostrar como se quiera
por ejemplo en este se podia haber puesto la cantidad de platos de cada primer pedido algo asi:
cliente  primer_pedido
A     CURRRY (X1) Y SUSHI (X1)
B     CURRY (X1)
C     RAMEN (X2)
D     SIN PEDIDO
Por ejemplo. Esto te lo comento para que os sintais libres de mostrar una salida de la forma que os apetezca no necesariamente igual que en la app, de hecho la evaluación de cada ejercicio siempre tiene un apartado "extra" para valorar estas posibles cosas. 
Pero tu ejercicio como he dicho todo correcto, muy bien haber usado el string_agg para no tener una fila por plato sino por pedido.

*/
