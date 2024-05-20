Select year, month, count(customer_id) as customer_number
from
		(
			Select
					year,
					month,
					customer_id,
					COUNT(deposit) as n_deposit,
					COUNT(purchase) as n_purchase,
					COUNT(withdrawal) as n_withdrawal
			from
					(Select 
						   datename(year,(txn_date))as year,
						   datename(month,(txn_date)) as month,
						   customer_id,
						   case when (txn_type = 'deposit') then 1  end as deposit,
						   case when (txn_type = 'purchase') then 1  end as purchase,
						   case when (txn_type = 'withdrawal') then 1 end as withdrawal
						   from case03.customer_transactions
					)as t

			group by year, month, customer_id
			
		)as t2
where (n_deposit > 1 and  n_purchase>1) or (n_withdrawal>1)
group by year, month
order by customer_number 


/*********************************************************/
/***************** COMENTARIO MARÍA *********************/
/*********************************************************/
/*

Perfecto y sencillo!

*/
