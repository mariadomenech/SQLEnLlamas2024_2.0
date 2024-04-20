SELECT 
	TOP 1
   PRODUCT_NAME,
	 COUNT(S.PRODUCT_ID) AS TOTAL_PEDIDO    
FROM 
    [case01].[sales] s 
LEFT JOIN 
    [case01].[menu] m ON s.product_id = m.product_id
GROUP BY
    m.product_name
ORDER BY
	COUNT(S.PRODUCT_ID) DESC;

/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*
El resultado para este caso concreto es correcto.
Sin embargo, esto no significa que el código sea correcto, ya que con TOP 1 solo estarías devolviendo el primer registro,
si hay empate en el primer puesto no devolvería todos los resultados y queremos que penséis si el resultado sería correcto
independientemente de los datos con los que trabajamos actualmente.

Para mejorarlo podríamos utilizar RANK() o DENSE_RANK() como en el reto 3 o la solución para utilizarlo con 
el TOP sería añadir el parámetro WITH TIES (que siempre tiene que ir acompañado de un ORDER BY)
que, en caso de empate, te muestra todas las filas que lo componen:

SELECT 
	TOP 1 WITH TIES -- sólo he añadido el WITH TIES
   PRODUCT_NAME,
	 COUNT(S.PRODUCT_ID) AS TOTAL_PEDIDO    
FROM 
    [case01].[sales] s 
LEFT JOIN 
    [case01].[menu] m ON s.product_id = m.product_id
GROUP BY
    m.product_name
ORDER BY
	COUNT(S.PRODUCT_ID) DESC;

*/
