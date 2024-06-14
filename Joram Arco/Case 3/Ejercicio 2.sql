/*
En esta tabla obtenemos los 3 primeros caracteres del mes de la fecha, además del propio año de la fecha. 
También realizamos la suma de los depósitos, las compras y las retiradas
*/
WITH calculos_clientes AS(
	SELECT
		customer_id
		,FORMAT(txn_date, 'MMM', 'ES') AS mes
		,YEAR(txn_date) AS anio
		,SUM(CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS depositos
		,SUM(CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS compras
		,SUM(CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS retiros
	FROM case03.customer_transactions
	GROUP BY customer_id
		,YEAR(txn_date)
		,FORMAT(txn_date, 'MMM', 'ES')
)

/*
Aquí obtemos el resultado final, con el conteo de clientes para cada año y mes, teniendo en cuenta el filtro 
de (depositos > 1 y compras > 1) o retiros > 1
*/
SELECT
	anio
	,mes
	,COUNT(customer_id) AS NUM_CLIENTES
FROM calculos_clientes
WHERE (depositos > 1 AND compras > 1) OR retiros > 1
GROUP BY anio
	,mes
ORDER BY 3 DESC --Para darle un orden por número de clientes en lugar de alfabéticamente por mes como aparece en la solución de la herramienta
;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto, sencillo. Te pongo un extra por tunearme los meses de la salida.

*/
