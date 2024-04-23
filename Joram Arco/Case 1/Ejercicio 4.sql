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
/*COMENTARIOS JUANPE:
TODO CORRECTO Y RESPECTO A TU COMENTARIO NO. Bien por no haber usado el top y solo haberlo comentado si no hubiera estado mal el codigo aunque bien la solución.
El motivo es que buscamos que el código siempre sea generico, que sirva para los datos actuales e incluso si los datos fueran otros, en este caso no hay empates,
pero si los hubiera un top 1 no te sacaría los dos que hubieran empatado, SALVO que aparte del TOP 1 usaras WITH TIES, si no lo conces te animo a buscarlo, sirve
para solventar el problema de los empates en el caso de usar TOP 1*/
