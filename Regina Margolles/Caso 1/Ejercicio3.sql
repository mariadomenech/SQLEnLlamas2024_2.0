
  Select t.customer_id as cliente,
          STRING_AGG(isnull(t.product_name,''),',') as productos
	from (
			Select distinct(c.customer_id),
					m.product_name,
					s.order_date,
					min(s.order_date) over (partition by c.customer_id order by c.customer_id) as min_order_date
			 from   case01.customers as c 
					left join case01.sales as s 
						on c.customer_id = s.customer_id
					left join case01.menu as m 
						on m.product_id = s.product_id
			group by  c.customer_id, s.order_date, m.product_name
		  ) as t 
	where t.order_date = t.min_order_date or t.order_date is null
	group by t.customer_id;
