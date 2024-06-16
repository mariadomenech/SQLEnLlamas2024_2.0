/*Reto 5 Crear funciones*/

CREATE FUNCTION JLMG_Ejercicio3_4_Total_depositos(@cliente int,@mes int,@anio int )
RETURNS decimal(18,2)
AS
-- Devuelve el total de depositos para un mes y uncliente determinados
BEGIN
    DECLARE @total decimal(18,2);
	 select @total=isnull(sum(txn_amount),0) 
			  from case03.customer_transactions
			  where customer_id=@cliente and 
					year(txn_date)=@anio and
					month(txn_date)=@mes and
					txn_type='deposit'
    RETURN @total
END
     go;
     
CREATE FUNCTION JLMG_Ejercicio3_4_Total_compras(@cliente int,@mes int,@anio int )
RETURNS decimal(18,2)
AS
-- Devuelve el total de depositos para un mes y uncliente determinados
BEGIN
    DECLARE @total decimal(18,2);
	 select @total=isnull(sum(txn_amount),0) 
			  from case03.customer_transactions
			  where customer_id=@cliente and 
					year(txn_date)=@anio and
					month(txn_date)=@mes and
					txn_type='purchase'
    RETURN @total
END
     go;

CREATE FUNCTION JLMG_Ejercicio3_4_Total_retiros(@cliente int,@mes int,@anio int )
RETURNS decimal(18,2)
AS
-- Devuelve el total de depositos para un mes y uncliente determinados
BEGIN
    DECLARE @total decimal(18,2);
	 select @total=isnull(sum(txn_amount),0) 
			  from case03.customer_transactions
			  where customer_id=@cliente and 
					year(txn_date)=@anio and
					month(txn_date)=@mes and
					txn_type='withdrawal'
    RETURN @total
END
go;


/* Reto5 , Crear un procedimiento almacenado que al introducir el identificador de cliente y el mes, calcule el total de compras y devuelva el mensaje
           "El cliente x , ha gastado un total de xxx eur en compras de productos en el mes de marzo"
		     usar las funcionas creadas para el calculo de compras, retiros y depositos*/

create procedure JLMG_Ejercicio3_5_TotalMovimientoClienteFunciones @tipo_calculo int,@cliente int,@mes int,@anio int   
as
/*
@tipo_calculo
1 -- Si queremos el balance
2 -- El total depositado
3 -- El total de compras
4 -- El total de retiros
*/


declare @depositos decimal(18,2)
declare @compras decimal(18,2)
declare @retiros decimal(18,2)
declare @total decimal(18,2)
declare @resultado varchar(150)


if @tipo_calculo=1  ---- Tipos 1 significa Balance Deposito - compras - retiros
   begin
		 set @compras=isnull([CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_compras](@cliente,@mes,@anio),0)
		 set @depositos=isnull([CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_depositos](@cliente,@mes,@anio),0)
		 set @retiros=isnull([CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_retiros](@cliente,@mes,@anio),0)
 	   set @total=@depositos-@compras-@retiros
	 
	     set @resultado='El balance del cliente '+convert(varchar,@cliente)+' para el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)+' es de '+convert(varchar,@total)+' euros'
end 
if @tipo_calculo=2  ---- Tipo 2 depositos
   begin
	   set @depositos=[CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_depositos](@cliente,@mes,@anio)
       set @total=isnull(@depositos,0)

	   if @total=0
		   begin
			   set @resultado='El cliente '+convert(varchar,@cliente)+' no ha tenido depositos en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end else
			begin 
			   set @resultado='El cliente '+convert(varchar,@cliente)+' ha depositado un total de '+convert(varchar,@total)+' euros en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end
	   
end 
if @tipo_calculo=3  ---- Tipo 3 compras
   begin
	  set @compras=isnull([CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_compras](@cliente,@mes,@anio),0)

       set @total=@compras
	   if @total=0
		   begin
			   set @resultado='El cliente '+convert(varchar,@cliente)+' no ha comprado en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end else
			begin 
			   set @resultado='El cliente '+convert(varchar,@cliente)+' ha comprado un total de '+convert(varchar,@total)+' euros en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end
	   
end 
if @tipo_calculo=4  ---- Tipo 4 retiros
   begin
	 set @retiros=isnull([CIVICA\joseluis.montalvo].[JLMG_Ejercicio3_4_Total_retiros](@cliente,@mes,@anio),0)

       set @total=@retiros
	   if @total=0
		   begin
			   set @resultado='El cliente '+convert(varchar,@cliente)+' no ha retirado en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end else
			begin 
			   set @resultado='El cliente '+convert(varchar,@cliente)+' ha retirado un total de '+convert(varchar,@total)+' euros en el mes de '+datename(month,'01-'+convert(varchar,@mes)+'-'+convert(varchar,@anio))+' de '+convert(varchar,@anio)
		   end	   
end 

if @tipo_calculo<1 or @tipo_calculo>4  --- Si nos pasan un tipo de cálculo no definido devolvemos un mensaje de error
  begin
     set @resultado='ERROR: Tipo de cálculo seleccionado no está no disponible'
  end

select @resultado;


/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Genial solución, muy legible y fácil de seguir. Lógica totalmente correcta. Como en los ejercicios anteriores,
se agradecería distintas llamadas al procedimiento cambiando parámetros.

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/

