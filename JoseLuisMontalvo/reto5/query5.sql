/* Tarjeta de fidelización , por cada euro gastado 10 puntos , por cada sushi consumido multiplicador x2
   Calcular los puntos que tiene cada cliente                    */


   declare @puntosxeuros int;
   declare @multiplicadorx2 int;
   declare @productomultiplicador int;

   set @puntosxeuros=10;  -- Puntos por cada euro
   set @multiplicadorx2= 2;  -- Factor de multiplicacion
   set @productomultiplicador = 1 ;  --- Producto multiplicador el sushi

   select Cliente,    
         sum(Puntos) as Puntos_totales
	   from (select cust.customer_id as Cliente,
			case when sal.product_id=@productomultiplicador then sum(isnull(men.price,0) * @puntosxeuros * @multiplicadorx2)  
			  else sum(isnull(men.price,0) * @puntosxeuros )   
			end as Puntos
		 from case01.customers cust
		      left join case01.sales sal on sal.customer_id=cust.customer_id
		      left join case01.menu men on men.product_id=sal.product_id
		      group by cust.customer_id ,sal.product_id) as Calcula_Puntos
group by Cliente;
