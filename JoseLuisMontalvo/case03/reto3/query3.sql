/* Reto3 , Crear un procedimiento almacenado que al introducir el identificador de cliente y el mes, calcule el total de compras y devuelva el mensaje
           "El cliente x , ha gastado un total de xxx eur en compras de productos en el mes de marzo"*/

create procedure JLMG_Ejercicio3_3_TotalCompras @cliente int,@mes int,@anio int   
as

declare @total decimal(18,2)
declare @resultado varchar(150)

select @total=sum(txn_amount) 
      from case03.customer_transactions
	  where customer_id=@cliente and 
	        year(txn_date)=@anio and
			month(txn_date)=@mes and
			txn_type='purchase'

if (@total is null or @total=0)
   begin
       set @resultado='El cliente '+convert(varchar,@cliente)+' no ha tenido gastos en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
   end else
    begin 
       set @resultado='El cliente '+convert(varchar,@cliente)+' se ha gastado un total de '+convert(varchar,@total)+' euros en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
   end

select @resultado;



/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Justo lo que se pedía, totalmente correcto y bien contemplado que el cliente pueda no haber gastado nada ese mes.

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/
