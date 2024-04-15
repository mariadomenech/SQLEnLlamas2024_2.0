select 
	a.customer_id AS CLIENTE
	, sum(coalesce(c.price,0)) AS GASTO
from 
	case01.customers a
	left join case01.sales b
		on a.customer_id = b.customer_id
	left join case01.menu c
		on b.product_id = c.product_id
group by a.customer_id
order by a.customer_id;

/*
Comentarios Juanpe.
Todo correcto. 
Resultado: OK
Código: OK. Bien partiendo de la de customers para obtener a todos hayan hecho alguna compra o no.
Legibilidad: OK
Sencillito este primer ejercicio, pero bueno para ir marcando los puntos que queremos evaluar, a parte de la solución en sí del ejercicio, cosas a valorar que si has reflejado en tu propuesta:
  - Bien por limpiar la salida para mostrar 0 y no ‘null’ en aquel que no ha hecho ninguna compra.
  - Bien por dar nombres a las columnas.
  - Bien por establecer un orden en la salida.
Ahora mismo esto parecen cosas triviales, pero no todo el mundo cae en hacerlas y estos detalles están la diferencia.
*/
