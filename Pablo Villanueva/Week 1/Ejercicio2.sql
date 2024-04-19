SELECT  C.customer_id,
  COUNT   ( DISTINCT Order_date) as  TOTAL_VISITAS
FROM case01.customers C
LEFT JOIN case01.sales S
	ON C.customer_id = S.customer_id
GROUP BY C.customer_id 
;



/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*

Perfecto Pablo! El resultado  y el código es correcto, por comentar algo se podría ordenar por
el número de visitas, a seguir así!!


*/
