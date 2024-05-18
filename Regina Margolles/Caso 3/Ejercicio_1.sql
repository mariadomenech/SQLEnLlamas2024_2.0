with cte1 
as
(
select customer_id,
	   node_id, 
     case 
        when (lag(node_id) over (partition by customer_id order by start_date) is null)
          then 0
	        else lag(node_id) over (partition by customer_id order by start_date) 
	   end as prev_node, 
	   start_date,
	   end_date
from case03.customer_nodes
),
  
cte2
as 
(select customer_id,
	      node_id, 
		    prev_node,
        start_date,
        DATEADD(day,-1, LEAD(start_date) over (partition by customer_id order by start_date)) as end_date
 from cte1
	WHERE (node_id != prev_node)
 ),
  
 CTE3
 as
 (
 select customer_id,
		    node_id,
		    prev_node,
		    DATEDIFF(day,start_date, end_date) as diff_days
	from CTE2 
 ),

 CTE4
 
 as
 ( select customer_id,
          node_id,
          diff_days,
          sum(diff_days) over (partition by customer_id)  sum_diff_days,
          count(node_id) over (partition by customer_id )  as number_node
   from CTE3
   where diff_days is not null
 ),

 CTE5
 as
 (
 select distinct customer_id, 
				sum_diff_days as dias,
				number_node as nodes
 from CTE4
 ),
 CTE6
 as
 (
 select  SUM(dias) as numerador, 
		     SUM(nodes) as denominador
 from CTE5
),
CTE7
as
(
   Select
         round(cast (numerador as float)/cast(denominador as float),2) as dias_reasignacion_media,
		     'Los clientes se reasignan a un nodo diferente cada ' + CAST(round(cast (numerador as float)/cast(denominador as float),2) AS VARCHAR) + ' días de media' as texto
   from CTE6
)
select * from CTE7;
