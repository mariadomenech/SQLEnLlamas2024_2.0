select cust.customer_id as Cliente      
	   ,Isnull ( ( Select sum(men2.price) from case01.menu men2 
			                     inner join case01.sales sal2
					           on  sal2.product_id=men2.product_id and sal2.customer_id=cust.customer_id 
			      ),0 ) as Gastado
from case01.customers cust
order by 2 desc;


/*
Comentarios Juanpe.
Todo correcto y grata sorpresa.

Resultado: OK

Código: OK. Y aquí mi sorpresa, muchos jurarian que el group by es necesario para este tipo de ejrecicios (y más en un ejercicio muy simple y parece indiscutible) y no me esperaba esta propuesta de solución, 
        la mayoría opta por cruzar las 3 tablas y un group by y listo, usar una subconsuta en el select yo personalmente lo veo como una propuesta de más nivel, y a mi personalmente me gusta.        

Legibilidad: OK. Si es cierto que aunque este punto en principio es subjetivo pero al menos hay parte objetiva, tabulaciones, saltos de linea... que cada uno con su manía pero son necesarias para que a un tercero 
             le sea más comodo revisar el código. Pues aún más subjetivo (o así lo veo yo) es cuando un código tiene subconsultas. 
             Completamente válido tu forma aunque te comparto como lo haría yo (ni mejor ni peor solo es mi forma con mis manías).*/
select cust.customer_id as Cliente      
     , isnull ( (select sum(men2.price)
	         from case01.menu men2 
                 inner join case01.sales sal2
                         on sal2.product_id  = men2.product_id 
                        and sal2.customer_id = cust.customer_id 
		) , 0 ) as Gastado
from case01.customers cust
order by 2 desc;
/*
Sencillito este primer ejercicio, pero bueno para ir marcando los puntos que queremos evaluar, a parte de la solución en sí del ejercicio, cosas a valorar que si has reflejado en tu propuesta:
  - Bien por limpiar la salida para mostrar 0 y no ‘null’ en aquel que no ha hecho ninguna compra.
  - Bien por dar nombres a las columnas.
  - Bien por establecer un orden en la salida y no tomar uno por defecto.
Ahora mismo esto parecen cosas triviales, pero no todo el mundo cae en hacerlas y estos detalles están la diferencia.

PD: algo en tu propuesta me dice que no eres nuevo en sql jeje los primeros ejercicios son más sencillos, conforme avance el curso habrá algunos más complicados, aunque no sé si lo suficiente como
para ponerte a sudar con ellos, pero aun así espero que disfrutes del curso.
*/


