SELECT cust.customer_id
, COUNT(DISTINCT sales.order_date) AS visit_total
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers cust
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales sales
	ON cust.customer_id = sales.customer_id
GROUP BY cust.customer_id
ORDER BY 1;
