--CASO 1: Ejercicio 2
SELECT  customers.customer_id,
--Cuenta de los días diferentes que ha visitado cada cliente el restaurante
		COUNT(DISTINCT sales.order_date) AS total_visits
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] customers
--Usamos LEFT JOIN para incluir los clientes sin registro de visitas
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] sales
	ON customers.customer_id = sales.customer_id
--Agrupammos por cliente para obtener el total de visitas de cada uno
GROUP BY customers.customer_id
--Ordenamos por cliente
ORDER BY customers.customer_id;