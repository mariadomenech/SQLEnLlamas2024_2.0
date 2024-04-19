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
