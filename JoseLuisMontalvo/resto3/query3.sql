 /*** Cúal son los primeros productos consumidos por el cliente ****/
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
