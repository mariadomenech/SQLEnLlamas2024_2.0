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
		
	  from case02.runner_orders
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
				 WHEN PATINDEX('%[0-9]%',exclusions)=1 THEN exclusions
				 WHEN PATINDEX('%[A-Z-a-z]%',exclusions)=1 THEN (SELECT CAST(topping_id AS VARCHAR(4)) 
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
	 )


Select  table1.runner_id,
        table1.orders,
	table1.number_pizzas_without_cancellation,
    	CASE
	        WHEN table1.total_orders= 0 THEN 0
	    	ELSE ROUND(table1.orders*100/cast(table1.total_orders as decimal(5,2)),2,1)  
    	END as percent_runner,
    	CASE
	        WHEN table1.number_pizzas_without_cancellation = 0 THEN 0
	    	ELSE ROUND(table2.number_pizzas_with_modifications*100/cast(table1.number_pizzas_without_cancellation as decimal(5,2)),2,1)
    	END as percent_pizzas
from (	
Select t.runner_id,t.orders, t.total_orders, t.number_pizzas_without_cancellation, t.number_pizzas
 from (
	Select  r.runner_id as runner_id,
	     	COUNT(ro.order_id) over (partition by r.runner_id) as number_pizzas,
  		CASE 
	                WHEN ro.cancellation IS NULL THEN
	      		     COUNT(ro.order_id)  over (partition by r.runner_id, ro.cancellation)
  		END as number_pizzas_without_cancellation, 
  	       (Select 
              		COUNT(r2.order_id)  
  		from CTE_runner_orders_clean  as r2 
  		where r2.runner_id = ro.runner_id and r2.cancellation is null
         	) as orders,
  		(Select 
              		COUNT(r2.order_id)
  		from CTE_runner_orders_clean as r2
  		where r2.runner_id = ro.runner_id)
		as total_orders,
  		row_number () over (partition by r.runner_id order by r.runner_id) as row_numbers
  	from
  	case02.runners as r
        left join  CTE_runner_orders_clean as ro
  		on r.runner_id = ro.runner_id
   	left join CTE_customer_orders_clean as c
  	 	on ro.order_id = c.order_id 		
   ) as t 
 where row_numbers = 1
) as table1
  left join (
      	Select  t.runner_id,t.number_pizzas_with_modifications
         	from
      		(
      		Select 
      			ro.runner_id as runner_id, 
      			count(ro.runner_id) as number_pizzas_with_modifications,
      			row_number() over (partition by ro.runner_id order by ro.runner_id) as row_numbers
      		from
      			CTE_runner_orders_clean as ro
      		left join CTE_customer_orders_clean as c
      			on ro.order_id = c.order_id 
      		where ro.cancellation is  null and (c.exclusions is not null or c.extras is not null)
      		group by ro.runner_id) as t
      	where row_numbers = 1) as table2
  on table1.runner_id = table2.runner_id;

  
