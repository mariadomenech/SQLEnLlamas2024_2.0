select
	customers.customer_id,
	isnull(sum(menu.price), 0) as total_gastado
from
	case01.sales sales
join
	case01.menu menu
on
	(sales.product_id = menu.product_id)
right join 
	case01.customers customers
on
	(sales.customer_id = customers.customer_id)
group by
	customers.customer_id
order by
	customers.customer_id asc;

/*
Comentarios Juanpe.
Todo correcto. 
Resultado: OK
Código: OK. Bien, buen uso del right para traer a todos hayan hecho alguna compra o no.
Legibilidad: OK
Sencillito este primer ejercicio, pero bueno para ir marcando los puntos que queremos evaluar, a parte de la solución en sí del ejercicio, cosas a valorar que si has reflejado en tu propuesta:
  - Bien por limpiar la salida para mostrar 0 y no ‘null’ en aquel que no ha hecho ninguna compra.
  - Bien por dar nombres a las columnas.
  - Bien por establecer un orden en la salida.
Ahora mismo esto parecen cosas triviales, pero no todo el mundo cae en hacerlas y estos detalles están la diferencia.
*/
