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
GROUP BY customers.customer_id
ORDER BY customers.customer_id;

/*
Comentarios Alex.
 
Resultado: Correcto
Código: Correcto
Legibilidad: Correcto

Todo genial:
 - Buen uso del ISNULL (también valdría COALESCE) en lugar de un CASE.
 - Bien los comentarios del código.
 - Muy bien el tratamiento de los nulos y contar con todos los customers.
 - Bien el renombrado y los alias de las tablas y bien la indentación.

Empezamos fácil, mucho ánimo con los siguientes! :)
*/
