select
 c.customer_id,
 coalesce(sum(price),0) as total
from case01.customers c
left join case01.sales s
on c.customer_id=s.customer_id
left join case01.menu m
on s.product_id=m.product_id
group by c.customer_id ;


/*
Comentarios Bea.
Todo correcto!

Resultado: OK
Código: OK
Legibilidad: OK 

Muy bueno el detalle de usar left joins y no full outer joins. Teniendo en cuenta la cantidad de datos que se manejan en este ejercicio no tiene importancia usar uno u otro, 
pero usar un full outer join sin necesidad nunca es recomendable.       
Además, genial la salida mostrando todos los clientes aunque no hayan realizado ninguna compra y sustituyendo los nulos por cero.
Como comentario personal, intentaría incluir un orden en la salida. Aunque en este caso tengamos muy pocas líneas como resultado, buscamos que sea lo más general y extrapolable posible. 

Este primer ejecicio es sencillito (ya se irá complicando un poquito), pero sirve para ir conociendo los puntos que queremos evaluar  
*/
