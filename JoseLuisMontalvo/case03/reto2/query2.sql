 /* creamos una temporal para ayudarnos a ver los depositos,compras y retiros por mes y cliente */
 with Agrupacion as (
select customer_id,
      year(txn_date) as Anio, 
	  DATENAME(month,txn_date) as Mes,
	  case when txn_type='deposit' then 1 Else 0 end as Deposito,
	  case when txn_type='purchase' then 1 Else 0 end as Compra,    
	  case when txn_type='withdrawal' then 1 Else 0  end as Retiro   
from case03.customer_transactions
	  )

---- Finalmente Sumamos y agrupamos por mes y cliente
select Anio,Mes,count(*) as N_Cliente from (select Anio,Mes,customer_id,sum(Deposito) as Deposito,sum(Compra) as Compra,sum(Retiro) as Retiro 
	                                       from Agrupacion
			  		     group by Anio,Mes,customer_id) as Agf
where (Deposito>1 and Compra>1) or Retiro>1
group by Anio,Mes;
