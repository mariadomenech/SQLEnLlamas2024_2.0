CREATE OR ALTER PROCEDURE Caso3_Ejercicio3 
@customer_id int = NULL,
@mes int  = NULL,
@resultado varchar(max) OUTPUT
AS
BEGIN
declare @total int
Set @total  = (Select 
					          SUM(txn_amount) as total
					     from case03.customer_transactions
				       where txn_type = 'purchase' and customer_id = @customer_id and MONTH(txn_date) = @mes) ;

if (@total is null) begin set @total = 0 end

SET @resultado = 'EL CLIENTE ' + cast(@customer_id as varchar) + 
			 ' SE HA GASTADO UN TOTAL '+ cast(@total as varchar) + 
			 ' EUR EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) ;
END


DECLARE
@resultado varchar(max);
EXEC Caso3_Ejercicio3 123, 5, @resultado OUTPUT
Select @resultado



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Perfecto!!

¿Por qué no me intentas hacer un control de errores? Por ejemplo, si consulto un cliente que no existe,
me devuelva un mensaje de error de que ese cliente no está en el sistema.

*/

/*********************************************************/
/***************** CORRECIÓN *********************/
/*********************************************************/

CREATE OR ALTER PROCEDURE RMC_Caso3_Ejercicio3 
@customer_id int = NULL,
@mes int  = NULL,
@resultado varchar(max) OUTPUT
AS
BEGIN TRY
	
declare @total int
if exists (Select customer_id 
	   from case03.customer_nodes 
	   where customer_id = @customer_id)
begin

	Set @total  = (Select   SUM(txn_amount) as total
		      from case03.customer_transactions
		       where txn_type = 'purchase' and customer_id = @customer_id and MONTH(txn_date) = @mes) ;
	
	if (@total is null) begin set @total = 0 end
	SET @resultado = 'EL CLIENTE ' + cast(@customer_id as varchar) + 
				 ' SE HA GASTADO UN TOTAL '+ cast(@total as varchar) + 
				 ' EUR EN EL MES DE ' + (SELECT DateName(month, DateAdd(month, @mes, -1))) ;
end else
	SET @resultado = 'EL CLIENTE NO ESTA REGISTRADO EN EL SISTEMA';

END TRY

BEGIN CATCH
   Select
		ERROR_NUMBER() as Error_Number,
		ERROR_MESSAGE() as Error_Message;

END CATCH
	
DECLARE
@resultado varchar(max);
EXEC [CIVICA\regina.margolles].RMC_Caso3_Ejercicio3 501,3,@resultado OUTPUT
Select @resultado
