WITH TABLA_TXN AS (SELECT 
	EOMONTH(TXN_DATE) AS MES_AÑO,
	CUSTOMER_ID,
	COUNT(CASE WHEN TXN_TYPE='deposit' then TXN_DATE else NULL END) AS DEPOSIT_X_MES,
	COUNT(CASE WHEN TXN_TYPE='purchase' then TXN_DATE else NULL END) AS PURCHASE_X_MES,
	COUNT(CASE WHEN TXN_TYPE='withdrawal' then TXN_DATE else NULL END) AS WITHDRAWAL_X_MES
FROM CASE03.CUSTOMER_TRANSACTIONS
GROUP BY
	CUSTOMER_ID,
	EOMONTH(TXN_DATE))

SELECT
	CONCAT(DATENAME(MONTH,MES_AÑO), ' de ', YEAR(MES_AÑO)) AS MES_DEL_AÑO,
	COUNT(CUSTOMER_ID) AS NUM_CLIENTES
FROM TABLA_TXN
WHERE (DEPOSIT_X_MES > 1 AND PURCHASE_X_MES > 1) OR WITHDRAWAL_X_MES > 1 
GROUP BY 
	MES_AÑO;

/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto, sencillo. Te pongo un extra por tunearme los meses de la salida.

*/
