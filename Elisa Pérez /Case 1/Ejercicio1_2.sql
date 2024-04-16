SELECT	C.customer_id, 
		    COUNT(DISTINCT(order_date)) num_dias
FROM case01.sales S
RIGHT JOIN case01.customers C
  ON S.customer_id = C.customer_id
GROUP BY C.customer_id;


/***********************************************/
/***************COMENTARIO DANI*****************/
/***********************************************/
/*Resultado correcto, buen manejo del DISTINCT para no contar varias veces el mismo día. Me gusta el 
enfoque del RIGHT JOIN ya que se ve que has tenido en cuenta el origen y apuntado de las tablas,
como detallín te recomiendo que las indentaciones las hagas con TAB. Enhorabuena Elisa, a darlo todo!*/
