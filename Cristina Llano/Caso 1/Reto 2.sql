SELECT cust.customer_id
, COUNT(DISTINCT sales.order_date) AS visit_total
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers cust
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
	ON cust.customer_id = sales.customer_id
GROUP BY cust.customer_id
ORDER BY 1;


/*********************************************************/
/***************** COMENTARIO BEA *********************/
/*********************************************************/
/*

Todo correcto!

Resultado: OK
Código: OK
Legibilidad: OK. Solo tabularía el COUNT para dejarlo alineado con "cust.customer_id" y el ON para hacer el código un poco más legible.

*/
