/*
En esta primera tabla obtenemos los 3 primeros caracteres del mes de la fecha, además del propio año de la fecha. 
También realizamos el conteo de los depósitos, las compras y las retiradas
*/
WITH calculos_clientes AS(
	SELECT
		customer_id
		,CONVERT(CHAR(3), DATENAME(MONTH, txn_date), 0) AS mes
		,YEAR(txn_date) AS anio
		,COUNT(CASE WHEN txn_type = 'deposit' THEN txn_type END) AS num_depositos
		,COUNT(CASE WHEN txn_type = 'purchase' THEN txn_type END) AS num_compras
		,COUNT(CASE WHEN txn_type = 'withdrawal' THEN txn_type END) AS num_retiros
	FROM case03.customer_transactions
	GROUP BY customer_id
		,txn_type
		,txn_date
),

/*
En esta segunda tabla hacemos el conteo de los clientes, así como las sumas de los conteos que hemos hecho
en la tabla anterior, para usarlas luego como filtro en la siguiente.
*/
suma_calculos AS(
	SELECT
		COUNT(DISTINCT customer_id) AS clientes
		,anio
		,mes
		,SUM(num_depositos) AS depositos
		,SUM(num_compras) AS compras
		,SUM(num_retiros) AS retiros
	FROM calculos_clientes
	GROUP BY customer_id
		,anio
		,mes
)

/*
Aquí calculamos la suma de los clientes por cada año y mes, teniendo en cuenta los depósitos, compras y retiradas.
También se podría haber hecho un HAVING en la tabla anterior de la forma HAVING (SUM(num_depositos) > 1 AND SUM(num_compras) > 1) OR SUM(num_retiros) > 1
*/
SELECT
	anio
	,LOWER(mes)+'.' AS mes --Para formatear el mes igual que viene en la herramienta de comparación
	,SUM(clientes) AS NUM_CLIENTES
FROM suma_calculos
WHERE (depositos > 1 AND compras > 1) OR retiros > 1
GROUP BY anio
	,mes
ORDER BY SUM(clientes) DESC --Para darle un orden por número de clientes en lugar de alfabéticamente por mes como aparece en la solución de la herramienta
;
