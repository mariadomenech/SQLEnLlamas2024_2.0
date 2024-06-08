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
		     case02.customer_orders as c
	
),
CTE3 
as 
(
  Select c.order_id,
         c.pizza_id,
         c.extras,
         c.exclusions,
         r.cancellation
  from CTE_customer_orders_clean as c
  left join CTE_runner_orders_clean as r
		on r.order_id = c.order_id
	where r.cancellation is null
),
CTE4
as
(
Select c.order_id,
       c.extras,
       c.exclusions,
       t.*
from CTE3 as c
left join case02.pizza_recipes as t
 on t.pizza_id = c.pizza_id
),
CTE5 
as 
(
Select c.order_id,
       c.pizza_id,
       c.exclusions,
       c.extras, 
       case 
       when c.extras is not null
			 then
			    concat(c.toppings,',',c.extras)
			 else 
				  c.toppings
			 end as toppings
from CTE4 as c
),
CTE6 
as
( 
select order_id,
       pizza_id,
       exclusions,
       extras,
       TRIM(value) as value
 from CTE5
 cross apply string_split(toppings,',')
),
CTE7
as
(
 select order_id,
        pizza_id,
        exclusions,
        extras,
        TRIM(value) as value
 from CTE5
 cross apply string_split(exclusions,',')
),
CTE8
as
(
 select value,
        COUNT(value) as used_time_number_toppings
 from CTE6
 group by value
),
CTE9
as
 (
 select value,
        COUNT(value) as used_time_number_exclusions
 from CTE7
 group by value
),
CTE10 
as 
( 
 select t.value as id_topping,
        p.topping_name, 
        case
        when e.used_time_number_exclusions is not null
        then
            t.used_time_number_toppings - e.used_time_number_exclusions  
        else
            t.used_time_number_toppings
        end as used_time_number_topping
 from CTE8 as t
 left join CTE9 as e
   on t.value = e.value
 left join case02.pizza_toppings as p
   on t.value = p.topping_id
),
CTE11
AS
(
  Select 
    RANK() over (order by used_time_number_topping desc) as ranking,
    used_time_number_topping,
	  STRING_AGG(topping_name,', ') WITHIN GROUP (ORDER BY topping_name) as toppings
  from CTE10
  group by (used_time_number_topping) 
)
SELECT * FROM CTE11;



/*
Corrección María: ¡Bien!

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK!
Legibilidad: OK, pero te pasa un poco igual que en el ejercicio 3 reduciría el uso de CTEs, hay muchos cálculos que puedes unificar en una misma consulta.
Al final es simplificar un poco el código.

*/
/*********************************************************/
/***************** CORRECIÓN *********************/
/*********************************************************/

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
		     case02.customer_orders as c
	
),
CTE3 
as 
(
  Select c.order_id,
         c.pizza_id,
         c.extras,
         c.exclusions,
         r.cancellation,
		 case 
		when c.extras is not null
			 then
			    concat(t.toppings,',',c.extras)
			 else 
				  t.toppings
		end as toppings
  from CTE_customer_orders_clean as c
  left join CTE_runner_orders_clean as r
	on r.order_id = c.order_id
  left join case02.pizza_recipes as t
	on t.pizza_id = c.pizza_id
  where r.cancellation is null
),

CTE4 
as
( 
select order_id,
       pizza_id,
       exclusions,
       extras,
       TRIM(value) as value
 from CTE3
 cross apply string_split(toppings,',')
),
CTE5
as
(
 select order_id,
        pizza_id,
        exclusions,
        extras,
        TRIM(value) as value
 from CTE3
 cross apply string_split(exclusions,',')
),
CTE6
as
(
 select value,
        COUNT(value) as used_time_number_toppings
 from CTE4
 group by value
),
CTE7
as
 (
 select value,
        COUNT(value) as used_time_number_exclusions
 from CTE5
 group by value
),
CTE8 
as 
( 
 select t.value as id_topping,
        p.topping_name, 
        case
        when e.used_time_number_exclusions is not null
        then
            t.used_time_number_toppings - e.used_time_number_exclusions  
        else
            t.used_time_number_toppings
        end as used_time_number_topping
 from CTE6 as t
 left join CTE7 as e
   on t.value = e.value
 left join case02.pizza_toppings as p
   on t.value = p.topping_id
),
CTE9
AS
(
  Select 
    RANK() over (order by used_time_number_topping desc) as ranking,
    used_time_number_topping,
	  STRING_AGG(topping_name,', ') WITHIN GROUP (ORDER BY topping_name) as toppings
  from CTE8
  group by (used_time_number_topping) 
)
SELECT * FROM CTE9;
