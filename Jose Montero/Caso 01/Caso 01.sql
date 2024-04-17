select	clientes.customer_id cliente,
		isnull(sum(price),0) as precio_total
from	case01.sales ventas
right join	case01.customers clientes
	on	ventas.customer_id=clientes.customer_id
left join	case01.menu precios
	on	precios.product_id=ventas.product_id
group by	clientes.customer_id
order by	clientes.customer_id asc

/*
Corrección Pablo: Todo correcto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien visto el cliente que no ha realizado ningún gasto en el restaurante.
Legibilidad: OK. Esto es más subjetivo, pero creo que el código puede presentarse un poco más ordenado de la siguiente manera:
*/

select	
	clientes.customer_id cliente,
	sum(isnull(precios.price,0)) as precio_total
from case01.sales ventas
right join case01.customers clientes
	on ventas.customer_id=clientes.customer_id
left join case01.menu precios
       on precios.product_id=ventas.product_id
group by clientes.customer_id
order by clientes.customer_id;

/*
Además, me ha gustado que nombres las columnas y ordenes la salida (recuerda que la ordenación es ascendente por defecto, así que no hace falta indicarlo).
Como detalle a comentar, si bien es cierto que la función de agregación SUM no tiene en cuenta los nulos, sería más correcto limpiar los nulos antes de la suma,
es decir, sum(isnull(precios.price,0)) en lugar de isnull(sum(price),0).
*/
