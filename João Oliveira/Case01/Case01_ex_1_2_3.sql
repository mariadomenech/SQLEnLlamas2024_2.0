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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien visto el cliente que no ha realizado ningún gasto en el restaurante.
Legibilidad: OK. Esto es más subjetivo, pero creo que se puede alinear un poco mejor la subconsulta para que sea más legible.

Además, me ha gustado que nombres las columnas. 
Como único detalle a comentar, si bien es cierto que la función de agregación SUM no tiene en cuenta los nulos,
personalmente considero más correcto limpiar los nulos antes de la suma, es decir, SUM(ISNULL(y.price,0)) en lugar de ISNULL(SUM(y.price),0).

¡Enhorabuena!
*/
	
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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK, aunque es cierto que el ISNULL no es necesario, el COUNT(b.customer_id) ya devuelve 0 si todos los valores son NULLs.
Además, se puede resolver evitando el GROUP BY de la subconsulta y empleando un COUNT(DISTINCT b.order_date):
*/

SELECT 
    a.customer_id
    , COUNT(DISTINCT b.order_date) AS count_visits
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers a
LEFT JOIN (
		SELECT
		    customer_id
		    , order_date
		FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
		) b 
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id
ORDER BY 2 DESC;

Legibilidad: OK. Esto es más subjetivo, pero a mí me gusta como has presentado el ejercicio, ahora sí que está
mejor tabulada la subconsulta.

Además, me ha gustado que ordenes la salida. ¡Enhorabuena!
*/

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

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Buen uso de la función de ventana RANK() para obtener el primer producto pedido por el cliente (haya empate o no).
Legibilidad: OK. El código es perfectamente legible, aunque soy fan de las CTEs que, bajo mi punto de vista, permiten que el 
código sea todavía más legible (te invito a probarlas en los próximos ejercicios).

Además, me ha gustado que agrupes los productos de un mismo cliente mediante la función STRING_AGG.

¡Enhorabuena!
*/
