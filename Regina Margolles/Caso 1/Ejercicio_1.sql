Select c.customer_id, isnull(SUM(m.price),0) 
from (
	  ( case01.customers as c left join case01.sales as s on c.customer_id = s.customer_id )
							              left join case01.menu as m on m.product_id = s.product_id)
group by c.customer_id;


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/* 

El resultado es completamente correcto.

Respecto a las tabulaciones, a mí me resulta más fácil leer las columnas tabuladas tras cada ',', es decir, expandiría la lista de columnas a mostrar.
Las palabras clave en mayúsculas, y los LEFT JOINs tabulados, así como su distintas condiciones. Los paréntesis entre joins en este caso no son necesarios.
Ejemplo:

SELECT c.customer_id
	,isnull(SUM(m.price), 0)
FROM case01.customers AS c 
LEFT JOIN case01.sales AS s 
	ON c.customer_id = s.customer_id
LEFT JOIN case01.menu AS m 
	ON m.product_id = s.product_id
GROUP BY c.customer_id;


Por último, dale un alias a la columna isnull(SUM(m.price),0) y PERFECTO!

*/
