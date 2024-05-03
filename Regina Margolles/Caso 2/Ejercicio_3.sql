with 
CTE_runner_orders_clean 
as 
	(	
		Select
		         order_id, 
			 runner_id,
			 pickup_time,
			 CASE
				  WHEN distance = '' THEN NULL
				  WHEN ISNUMERIC(distance) = 1 THEN distance
				  WHEN PATINDEX('%[A-Za-z]%',distance) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',distance) = 1 THEN TRIM(SUBSTRING(distance,0, CHARINDEX('k',distance)))
			END as distance,
			CASE
				  WHEN duration = '' THEN NULL
				  WHEN ISNUMERIC(duration) = 1 THEN duration
				  WHEN PATINDEX('%[A-Za-z]%',duration) = 1 THEN NULL
				  WHEN PATINDEX('%[0-9]%',duration) = 1 THEN TRIM(SUBSTRING(duration,0, CHARINDEX('m',duration)))
		    END as duration,
			CASE
				  WHEN cancellation = '' THEN NULL
				  WHEN PATINDEX('%null%',cancellation) = 1 THEN NULL
				  WHEN PATINDEX('%[A-Za-z]%',cancellation) = 1 THEN cancellation
		    END as cancellation
		
	  from 
			case02.runner_orders
	)
	,
CTE_customer_orders_clean 
as 
	(
		Select 
			  order_id, 
			  customer_id,
			  pizza_id,
			  CASE 
				 WHEN PATINDEX('',exclusions)=1 THEN NULL
				 WHEN PATINDEX('%null%',exclusions)=1 THEN NULL
				 WHEN PATINDEX('%[^0-9]%',exclusions)=0 THEN exclusions
				 WHEN PATINDEX('%[^A-Z-a-z]%',exclusions)=0 THEN (SELECT CAST(topping_id AS VARCHAR(4)) 
							                          FROM case02.pizza_toppings 
										  WHERE topping_name = exclusions)
			  END as exclusions, 
			  CASE 
				 WHEN PATINDEX('',extras)=1 THEN NULL
				 WHEN PATINDEX('%null%',extras)=1 THEN NULL
				 WHEN PATINDEX('%[0-9]%',extras)=1 THEN extras
				 WHEN PATINDEX('%[A-Z-a-z]%',extras)=1 THEN (SELECT CAST(topping_id AS VARCHAR(4)) 
										     FROM case02.pizza_toppings 
										     WHERE topping_name = extras)
			  END as extras,
			  order_time	 
		 from
		     case02.customer_orders
	 ),

CTE1 
as
(Select c.order_id,
		c.pizza_id, 
		p.pizza_name,
		c.extras, 
		r.runner_id,
		r.distance, 
		CASE
	      WHEN 
		p.pizza_name = 'Meatlovers'  THEN 12
	      WHEN 
	        p.pizza_name = 'Vegetarian'   THEN 10
	    END as price_pizza,
		 (cast(r.distance as decimal(5,2)) * 0.30) as travel_cost,
		 row_number () over (partition by c.order_id order by c.order_id) as number_row
 from CTE_customer_orders_clean as c
     left join CTE_runner_orders_clean as r
	on c.order_id = r.order_id
     inner join case02.pizza_names as p
	on c.pizza_id = p.pizza_id
 where r.cancellation is null),
  
CTE2
as(

select *,
        (SELECT count(*) FROM STRING_SPLIT(CTE1.extras,',')) as extras_pizza

from CTE1
group by  CTE1.order_id,
          CTE1.pizza_id,
	  CTE1.pizza_name,
	  CTE1.extras, 
	  CTE1.runner_id,
	  CTE1.distance,
	  CTE1.travel_cost,
	  CTE1.price_pizza,
	  CTE1.number_row),
	
CTE3 
as(
	select *,
	SUM(CTE2.price_pizza + (CTE2.extras_pizza)) over (partition by CTE2.order_id) as subtotal
	from CTE2
),


CTE4
as(

select  CTE3.order_id,
		CTE3.subtotal - CTE3.travel_cost as profit

from CTE3

),
CTE5
AS  (
select * from CTE4
       
group by CTE4.order_id, CTE4.profit
)

Select SUM(profit) from CTE5;
