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
	      (Select total_deposit - total_purchase - total_withdrawal as total
		     from
    		  (
    			  Select sum(deposit) as total_deposit, 
                   sum(purchase) as total_purchase, 
                   sum(withdrawal) as total_withdrawal
    		 
    			  from
    			  (
    					Select customer_id, txn_date,
    						   case when [deposit] is null then 0 else [deposit] end as deposit,
    						   case when [purchase] is null then 0 else [purchase] end as purchase,
    						   case when [withdrawal] is null then 0 else [withdrawal] end as withdrawal
    					from
    					(
    						Select customer_id, txn_amount, txn_type, txn_date
    						from case03.customer_transactions
    					)	src_table
    					pivot
    						(sum(txn_amount)
    						 for txn_type in ([deposit], [purchase], [withdrawal])
    					) as pivot_table
    			   ) as t	
    			where (customer_id = @customer_id) and (MONTH(txn_date)= @mes)
    			)as t2
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

if (@total is null) begin set @total = 0 end


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
