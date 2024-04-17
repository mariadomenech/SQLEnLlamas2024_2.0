select	clientes.customer_id cliente
		, count(distinct(ventas.order_date)) as dias_visitados
from	case01.sales ventas
right join	case01.customers clientes
	on	ventas.customer_id=clientes.customer_id
group by	clientes.customer_id
order by	1

/*
Corrección Pablo: Todo correcto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien aplicado el COUNT DISTINCT.
Legibilidad: OK. Esto es más subjetivo, pero creo que el código puede presentarse un poco más ordenado de la siguiente manera:
*/

select	
    clientes.customer_id cliente
    , count(distinct(ventas.order_date)) as dias_visitados
from case01.sales ventas
right join case01.customers clientes
    on ventas.customer_id=clientes.customer_id
group by clientes.customer_id
order by 1

/*
Además, me ha gustado que ordenes la salida. ¡Enhorabuena!
*/
