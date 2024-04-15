SELECT c.customer_id, COALESCE(SUM(m.price), 0) AS total_gastado
FROM case01.customers c
	LEFT OUTER JOIN case01.sales s ON c.customer_id = s.customer_id
	LEFT OUTER JOIN case01.menu m ON s.product_id = m.product_id
GROUP BY c.customer_id;

/*
Comentarios Juanpe.
Todo correcto. 
Resultado: OK
Código: OK. Bien partiendo de la de customers para obtener a todos hayan hecho alguna compra o no.
Legibilidad: OK. Ok de moemento porque es una query muy corta pero unos tips que te pueden servir para querys más largas, es separar los campos de la select por salto de linea
             y las condiciones de cruce en este caso solo tienes una pero podría dentro del "ON" tener varias condicoines unidas con "AND" y no sería recomendable en una sola 
             linea por ello te propongo algo así:*/
			SELECT c.customer_id
			     , COALESCE(SUM(m.price), 0) AS total_gastado
			     , ....
			     , ....
			FROM case01.customers c
			LEFT JOIN case01.sales s 
			       ON c.customer_id = s.customer_id
			      AND ....	
			LEFT JOIN case01.menu m 
			       ON s.product_id = m.product_id
			      AND ...
			GROUP BY c.customer_id;
/*Hay muchas maneras validas pues este tema tiene una buena parte subjetiva pero así es como yo suelo tabular y ordenar el código. También puedes comprobar que la coma para separar 
campos la pongo al inicio del siguiente en lugar de al final del primero, por simple manía, la uso para alinear los campos, me gusta como queda visualmente a la hora de leer código,
Pero repito son tips no hay una forma correcta universal. Por cierto LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN, a todos se le puede omitir el OUTER sin que tenga un efecto 
distinto, yo soy de los que prefiere no ponerlo pero es completamente válido ponerlo.

Sencillito este primer ejercicio, pero bueno para ir marcando los puntos que queremos evaluar, a parte de la solución en sí del ejercicio, cosas a valorar que si has reflejado en tu propuesta:
  - Bien por limpiar la salida para mostrar 0 y no ‘null’ en aquel que no ha hecho ninguna compra.
  - Bien por dar nombres a las columnas.
Ahora mismo esto parecen cosas triviales, pero no todo el mundo cae en hacerlas y estos detalles están la diferencia.
*/
