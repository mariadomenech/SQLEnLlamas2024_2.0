
ALTER PROCEDURE  JCP_Ejercicio3_4_SP_TransaccionesClientes @cliente_id int, @mes int, @Transaccion varchar(20)


AS
BEGIN
	
	if exists(
		select * from [case03].[customer_transactions]
		where customer_id= @cliente_id
		and MONTH(txn_date)= @mes)
	begin

select 
'El Cliente ' + cast(customer_id as varchar(10)) + ' tiene un total de ' + cast(cantidad as varchar(10)) 
			+ ' Eur en ' 
			+ @Transaccion
			+ ' en el mes de '
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
			case when @Transaccion = 'Balance'  then balance_total
				when @Transaccion = 'depositos'  then depositos
				when @Transaccion = 'compras'  then compras
				when @Transaccion = 'retiros'  then retiros
			end as cantidad
			, a.*
		from
		(
		select 
			a.*
			, depositos - compras - retiros as balance_total
			from
			(
			select 
				customer_id 
				, month(txn_date) as mes
				,ISNULL( sum(case when txn_type = 'purchase' then txn_amount end),0) as compras
				, ISNULL( sum(case when txn_type = 'deposit' then txn_amount end),0) as depositos
				, isnull(sum(case when txn_type = 'withdrawal' then txn_amount end),0) as retiros
			from
				[case03].[customer_transactions]
			group by 
				customer_id 
				, month(txn_date)
			)a
)a


where 
			customer_id= @cliente_id
			and mes = @mes
)a;

end
	else 
		  begin
		select 'Sin datos para los parametros introducidos';
	end;

END;
