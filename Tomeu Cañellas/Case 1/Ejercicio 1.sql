--CASO 1: Ejercicio 1
SELECT  customers.customer_id,
--Para los clientes sin registros de ventas en la tabla SALES, sustituimos NULL por el valor 0
	ISNULL(SUM(menu.price), 0) AS total_profit
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] customers
--Usamos LEFT JOIN para incluir los clientes sin registro de ventas
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
	ON customers.customer_id = sales.customer_id
--Usamos LEFT JOIN para incluir los clientes sin registro de ventas
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] menu
	ON sales.product_id = menu.product_id
--Agrupamos por cliente para obtener el total gastado por cada uno
GROUP BY customers.customer_id;
