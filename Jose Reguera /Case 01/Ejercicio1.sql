select B.customer_id as NombreCliente ,
	Isnull(sum(C.price),0) as Dinero_Gastado 

from case01.sales A

  full outer join case01.customers B
	 on A.customer_id=B.customer_id
  full outer join case01.menu C
	 on A.product_id=C.product_id

	 group by B.customer_id;

/*
Comentarios Juanpe.
 
Resultado: OK
Código: En primer lugar no es muy óptimo, es cierto que para la cantidad de datos que se manejan en este ejercicio no tiene importancia pero usar un full outer join sin necesidad nunca es recomendable, hubiera sido "más correcto" una de estas dos opciones:
        - from sales --> left/inner join menu --> right join customers
        - from customers --> left join sales --> left join menu
        Pero ya no es es solo un tema de optimización, es un tema de que no es del todo correcto si los datos fueran otros. Un ejmplo, vamos a suponer que hay en la tabla menu un producto que nadie ha pedido, ¿que ocurriría con tú código? Vamos a añadirle
        a la tabla menu un nuevo registro de forma virtual con un union all por ejemplo.*/
			select B.customer_id as NombreCliente ,
				   Isnull(sum(C.price),0) as Dinero_Gastado 
			from case01.sales A
			full outer join case01.customers B
				 on A.customer_id=B.customer_id
			full outer join (select * from	case01.menu
			                   union all
			                 select 4, 'pizza', 10) C
				 on A.product_id=C.product_id
			group by B.customer_id;
			Si ejecutas verás lo que sale: 
			Cliente| €
			-------|---
			null   | 10
			A      | 76
			B      | 74
			C      | 36
			D      | 0
/*
Legibilidad: OK. Pero como detalle te comento que no es bueno dejar lineas vacías en medio de una consulta, algunos IDE no le afecta como SSMS aunque otros puede que sí, yo en mi caso en el proyecto que estoy para ejecutar querys
             en producción debemos hacerlo mandado dicha query a una maquina linux y no le suele gustar las lineas vacías
Sencillito este primer ejercicio, pero bueno para ir marcando los puntos que queremos evaluar, a parte de la solución en sí del ejercicio, cosas a valorar que si has reflejado en tu propuesta:
  - Bien por limpiar la salida para mostrar 0 y no ‘null’ en aquel que no ha hecho ninguna compra.
  - Bien por dar nombres a las columnas.
Ahora mismo esto parecen cosas triviales, pero no todo el mundo cae en hacerlas y estos detalles están la diferencia.
*/
