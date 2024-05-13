create PROCEDURE sp_ComprasClienteMes @cliente_id int, @mes int
AS
BEGIN
	
	if exists(
		select * from [case03].[customer_transactions]
		where customer_id= @cliente_id
		and MONTH(txn_date)= @mes)
	begin
		select 
		'El Cliente ' + cast(customer_id as varchar(10)) + ' se ha gastado un total de ' + cast(cantidad as varchar(10)) 
		+ ' Eur en compras de productos en el mes de '
		+ case  mes 
			when 1 then 'enero'
			when 2 then 'febrero'
			when 3 then 'marzo'
			when 4 then 'abril'
			when 5 then 'mayo'
			when 6 then 'jun'
			when 7 then 'julio'
			when 8 then 'agosto'
			when 9 then 'septiembre'
			when 10 then 'octubre'
			when 11 then 'noviembre'
			when 12 then 'diciembre'
		end

		from

		(
		select 
			customer_id 
			, month(txn_date) as mes
			, sum(txn_amount) as cantidad
		from
		[case03].[customer_transactions]
		where txn_type = 'purchase'

		group by customer_id , month(txn_date)
		)a
		where 
			customer_id= @cliente_id
			and mes = @mes;
		end
	else 
		  begin
		select 'Sin datos para los parametros introducidos';
	end;

END;
