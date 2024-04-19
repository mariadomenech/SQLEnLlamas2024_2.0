select 
cli.customer_id as cliente
,sum(coalesce( b.price * case when b.product_id = 1 then 20  else 10 end ,0)) as puntos
	from 
		case01.customers cli
		left join [case01].[sales] a
			on a.customer_id = cli.customer_id	
		left join case01.menu b
			on a.product_id = b.product_id
group by cli.customer_id
order by cli.customer_id
;
