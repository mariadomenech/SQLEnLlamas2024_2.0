CREATE OR ALTER PROCEDURE RMC_Caso3_Ejercicio4
@customer_id int = NULL,
@mes int  = NULL,
@operacion int = NULL,
@resultado varchar(max) OUTPUT

AS
BEGIN


declare @total int
declare @movimiento varchar(10)

Set @total =
  Case 
	 when (@operacion = 1) then
	      (Select deposit - purchase - withdrawal as total
		   from
		  (
			  
					Select sum(coalesce(deposit,0)) as deposit, 
					       sum(coalesce(purchase,0)) as purchase,
					       sum(coalesce(withdrawal,0)) as withdrawal
						  
					from
					(
						Select customer_id, txn_amount, txn_type, txn_date
						from case03.customer_transactions
						where (customer_id = @customer_id) and (MONTH(txn_date)= @mes)
					)	src_table
					pivot
						(sum(txn_amount)
						 for txn_type in ([deposit], [purchase], [withdrawal])
					) as pivot_table
			   ) as t	
			
		)
	 when (@operacion = 2) then
	       (Select SUM(txn_amount) as total
			  from case03.customer_transactions
			  where txn_type = 'deposit' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	 when (@operacion = 3) then		
			 (Select SUM(txn_amount) as total
			  from case03.customer_transactions
			  where txn_type = 'purchase' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	 when (@operacion = 4) then
			(Select SUM(txn_amount) as total
			 from case03.customer_transactions
		     where txn_type = 'withdrawal' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	  end

  set @total = coalesce(@total,0)


Set @movimiento = 
	  Case when @operacion=1 then 'balance'
		   when @operacion=2 then 'deposito'
		   when @operacion=3 then 'compra'
		   when @operacion=4 then 'retirada'
	  end

SET @resultado =
             Case
			 when (@operacion = 1) then
			 'EL CLIENTE ' + cast(@customer_id as varchar) + 
			 ' HA OBTENIDO UN BALANCE DE '+ cast(@total as varchar) + 
			 ' EUR EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) 
			 else
			 'EL CLIENTE ' + cast(@customer_id as varchar) + 
			 ' SE HA GASTADO UN TOTAL '+ cast(@total as varchar) + 
			 ' EUR EN ' + @movimiento + ' EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) 
			 end


END

/*********************************************************/
/***************** CORRECIÓN *********************/
/*********************************************************/



CREATE OR ALTER PROCEDURE RMC_Caso3_Ejercicio4
@customer_id int = NULL,
@mes int  = NULL,
@operacion int = NULL,
@resultado varchar(max) OUTPUT

AS
BEGIN TRY


declare @total int
declare @movimiento varchar(10)


Set @total =
  Case 
	 when (@operacion = 1) then
	      (Select deposit - purchase - withdrawal as total
		   from
		  (
			  
					Select sum(coalesce(deposit,0)) as deposit, 
					       sum(coalesce(purchase,0)) as purchase,
					       sum(coalesce(withdrawal,0)) as withdrawal
						  
					from
					(
						Select customer_id, txn_amount, txn_type, txn_date
						from case03.customer_transactions
						where (customer_id = @customer_id) and (MONTH(txn_date)= @mes)
					)	src_table
					pivot
						(sum(txn_amount)
						 for txn_type in ([deposit], [purchase], [withdrawal])
					) as pivot_table
			   ) as t	
			
		)
	 when (@operacion = 2) then
	       (Select SUM(txn_amount) as total
			  from case03.customer_transactions
			  where txn_type = 'deposit' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	 when (@operacion = 3) then		
			 (Select SUM(txn_amount) as total
			  from case03.customer_transactions
			  where txn_type = 'purchase' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	 when (@operacion = 4) then
			(Select SUM(txn_amount) as total
			 from case03.customer_transactions
		     where txn_type = 'withdrawal' and customer_id = @customer_id and MONTH(txn_date) = @mes) 
	  end

set @total= coalesce(@total,0)


Set @movimiento = 
	  Case when @operacion=1 then 'balance'
		   when @operacion=2 then 'deposito'
		   when @operacion=3 then 'compra'
		   when @operacion=4 then 'retirada'
	  end



SET @resultado =
  case when not exists (Select customer_id 
					from case03.customer_nodes 
					where customer_id = @customer_id) 
		then 'EL CLIENTE NO ESTA REGISTRADO EN EL SISTEMA'
		when @operacion not in (1,2,3,4) then
		'LA OPERACION INTRODUCIDA NO ES VALIDA'
		else
		   Case
			 when (@operacion = 1) then
			 'EL CLIENTE ' + cast(@customer_id as varchar) + 
			 ' HA OBTENIDO UN BALANCE DE '+ cast(@total as varchar) + 
			 ' EUR EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) 
			 else
			 'EL CLIENTE ' + cast(@customer_id as varchar) + 
			 ' SE HA GASTADO UN TOTAL '+ cast(@total as varchar) + 
			 ' EUR EN ' + @movimiento + ' EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) 
			 end
		end
 
END TRY

BEGIN CATCH
   Select
		ERROR_NUMBER() as Error_Number,
		ERROR_MESSAGE() as Error_Message
		

END CATCH

DECLARE
@resultado varchar(max);
EXEC [CIVICA\regina.margolles].RMC_Caso3_Ejercicio4 123,12,3,@resultado OUTPUT
Select @resultado



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Enhorabuena!!

Código: OK
Legibilidad: OK
Resultado: Muy completo!

*/

