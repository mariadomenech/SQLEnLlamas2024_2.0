WITH tmp AS
(
	SELECT  C.customer_id AS customer_id
    		, CASE  WHEN S.product_id = 1 
    				THEN 10*2*SUM(M.price)
    				ELSE 10*SUM(M.price)
    		  END AS puntos
	FROM case01.sales S
	LEFT JOIN case01.menu M
		ON S.product_id = M.product_id
	RIGHT JOIN case01.customers C
		ON S.customer_id = C.customer_id
	GROUP BY C.customer_id, S.product_id
)
SELECT	customer_id
		, SUM(puntos) AS puntos
FROM tmp
GROUP BY customer_id;


/***********************************************/
/***************COMENTARIO DANI*****************/
/***********************************************/
/*Resultado Correcto!. Muy buen uso de una CTE para manejo de la lógica 
y poder recurrir posteriormente a ella. Muy buena legibilidad, el único
fallito ha sido no tener en cuenta el control de NULLS, en el caso del 
cliente D esta consulta nos devuelve NULL, sin embargo siempre en esos 
casos hay que establecer un manejo de los mismos, algo que diga 'No hay puntos',
o simplemente '0' para que el consumo de los datos sean lo mas claro y limpios
posibles. Enhorabuena Elisa!, no hay avance sin errores al igual que no hay
DELETE sin WHERE! Sigue así!*/
