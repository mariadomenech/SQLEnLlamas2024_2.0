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


SELECT TOP (1)
  M.PRODUCT_NAME PRODUCTO,
  COUNT(S.PRODUCT_ID) VECES_PEDIDO
FROM CASE01.MENU M
JOIN CASE01.SALES S
  ON M.PRODUCT_ID = S.PRODUCT_ID
GROUP BY M.PRODUCT_NAME
ORDER BY VECES_PEDIDO DESC;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Resultado correcto, enhorabuena David!

Resultado: OK
Código: En este caso el resultado sale correcto utilizando un TOP, pero no nos sirve para ver cuando haya empates entre productos más vendidos.
	Para tener en cuenta esta casuística, podríamos utilizar un RANK. Te dejo una forma de hacerlo:

		SELECT 
			data.product_name
			,data.num_ventas
		FROM
		(
			SELECT 
				 menu.product_name
				,COUNT(sales.customer_id) AS num_ventas
				,RANK() OVER( ORDER BY COUNT(sales.customer_id) DESC) AS rank_ventas
			FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
			INNER JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu menu
				ON menu.product_id = sales.product_id
			GROUP BY  menu.product_name
		) data
		WHERE rank_ventas = 1;
Legibilidad: OK. 
