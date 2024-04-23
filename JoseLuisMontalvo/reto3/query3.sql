 /*** Cuales son los primeros productos consumidos por el cliente ****/
 select Cliente as Cliente,
        string_agg (Primer_producto,',') as Primer_producto
 from  (select  distinct cust.customer_id as Cliente,
         isnull(men.product_name,'') as Primer_producto
          from case01.customers cust		      
              left join case01.sales sal 
			   on sal.customer_id=cust.customer_id and (sal.order_date=(select min(sal2.order_date)
						                                                 from case01.menu men2         --- Obtenemos la fecha de la primera visita
		                                                                  inner join case01.sales sal2
									                                      on men2.product_id=sal2.product_id
								                                          and sal2.customer_id=cust.customer_id))      
			  left join case01.menu men 
			  on men.product_id=sal.product_id ) 
        as tabla_aux  
group by Cliente;

/*COMENTARIOS JUANPE
TODO CORRECTO. El nulo siempre es bueno limpiarlo con algun valor por defecto aunque sean ' ' o 'sin pedido', la gracia es no dejar null. Otras ideas para que te sirva en futuros ejercicios, los resultados se pueden mostrar como se quiera
por ejemplo en este se podia haber puesto la cantidad de platos de cada primer pedido algo asi:
cliente  primer_pedido
A     CURRRY (X1) Y SUSHI (X1)
B     CURRY (X1)
C     RAMEN (X2)
D     SIN PEDIDO
Por ejemplo. Esto te lo comento para que os sintais libres de mostrar una salida de la forma que os apetezca no necesariamente igual que en la app, de hecho la evaluación de cada ejercicio siempre tiene un apartado "extra" para valorar estas posibles cosas. 
Pero tu ejercicio como he dicho todo correcto, muy bien haber usado el string_agg para no tener una fila por plato sino por pedido.

*/
