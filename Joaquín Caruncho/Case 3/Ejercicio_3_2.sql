select 
	año
	,case mes
		when 1 then 'enero'
		when 2 then 'febrero'
		when 3 then 'marzo'
		when 4 then 'abril'
		when 5 then 'mayo'
		when 6 then 'junio'
		when 7 then 'julio'
		when 8 then 'agosto'
		when 9 then 'septiembre'
		when 10 then 'octubre'
		when 11 then 'noviembre'
		when 12 then 'diciembre'
	end as mes
	,count(distinct customer_id) as clientes
from
(
	select 
		customer_id 
		, year (txn_date) as año
		, month (txn_date) as mes
		, sum(case when txn_type = 'deposit' then 1 else 0 end) as deposito
		, sum(case when txn_type = 'purchase' then 1 else 0 end) as compra
		, sum(case when txn_type = 'withdrawal' then 1 else 0 end) as retiro
	from 
		case03.customer_transactions
	group by 
	customer_id 
	, year (txn_date)
	, month (txn_date)
)a
where  
	(deposito>1  and compra >1)  or retiro >1
group by año, mes

order by año, mes;
