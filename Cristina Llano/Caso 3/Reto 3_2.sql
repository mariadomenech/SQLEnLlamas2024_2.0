/* Para cada mes, ¿cuántos clientes realizan más de un depósito y una compra o un retiro de un solo mes?*/

-- Al ser sencilla he decidido no crear tablas temporales.

/* Se vuelve agrupar por año y mes quedándonos únicamente con los clientes que cumple las casuísticas esperadas
para hacer un conteo de los mismos y obteniendo los datos descendientemente por número de clientes*/
SELECT fecha_anio_num
	, fecha_mes_texto
	, COUNT (customer_id) num_clientes_totales
FROM 
(	/*Se obtiene la base de la suma de cada transación agrupada por cliente, año y mes en formato texto 
	que es más legible, aunque no se aconseja agrupar por texto ya que puede ser menos eficiente. */
	SELECT customer_id
		, YEAR (txn_date) AS fecha_anio_num
		, DATENAME (MONTH,txn_date) AS fecha_mes_texto
		, SUM (CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS num_desposito
		, SUM (CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END) AS num_retiro
		, SUM (CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END) AS num_compras
	FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_transactions
	GROUP BY customer_id
		, YEAR (txn_date)
		, DATENAME (MONTH,txn_date)
) BASE
WHERE (num_desposito > 1 AND num_compras > 1 ) OR num_retiro > 1
GROUP BY fecha_anio_num
  , fecha_mes_texto
ORDER BY 3 DESC;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Todo correcto, enhorabuena!!

Resultado: OK
Código: OK
Legibilidad: OK

Me gusta que no te "compliques la vida", lo haces muy sencillo explicándo cada paso y ordenando los resultados (que nunca está de más).

*/
