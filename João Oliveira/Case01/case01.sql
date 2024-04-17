/* CASE01

 Question 1: ¿Cuánto ha gastado en total cada cliente en el Restaurante?
 Question 2: ¿Cuántos días ha visitado el restaurante cada cliente?
 Question 3: ¿Cuál es el primer producto que ha pedido cada cliente?
*/


-- Question 1: ¿Cuánto ha gastado en total cada cliente en el Restaurante?
select
	a.customer_id
	,isnull(b.total_spend,0) as total_spend_$
from SQL_EN_LLAMAS_ALUMNOS.case01.customers a
Left join (select x.customer_id
				 ,sum(y.price) as total_spend
			from SQL_EN_LLAMAS_ALUMNOS.case01.sales x 
			left join SQL_EN_LLAMAS_ALUMNOS.case01.menu y
			on x.product_id = y. product_id
			group by x.customer_id
			) b
	on a.customer_id = b.customer_id;
	
-- Question 2: ¿Cuántos días ha visitado el restaurante cada cliente?
  -- se considera que el cliente que visita el restaurante en el mismo día cuenta solo como 1 visita

select 
	a.customer_id
	,isnull(count(b.customer_id),0) as count_visits
	from SQL_EN_LLAMAS_ALUMNOS.case01.customers a
Left join (
		select
			customer_id
			,order_date
		from SQL_EN_LLAMAS_ALUMNOS.case01.sales
		group by customer_id, order_date
		) b 
on a.customer_id = b.customer_id
group by a.customer_id
order by isnull(count(b.customer_id),0)  desc
;


-- Question 3: ¿Cuál es el primer producto que ha pedido cada cliente?

select 
	customer_id,
	isnull(STRING_AGG(product_name, ', '),'') AS first_order_products
from (select distinct
	b.customer_id
	,a.order_date
	,c.product_name
	,rank() over(partition by a.customer_id order by a.order_date) as rank
from case01.sales a
right join case01.customers b on a.customer_id = b.customer_id
left join case01.menu c on a.product_id = c.product_id
) x
where rank = 1
group by customer_id
order by customer_id;
