
-- Question 4: ¿Cuál es el producto más pedido del menú y cuántas veces ha sido pedido?

select TOP 1
    a.product_id,
    count(b.product_id) as number_orders
from case01.menu a
LEFT JOIN case01.sales b on a.product_id = b.product_id
group by a.product_id
order by number_orders desc;



/*
-- Question 5: Josep quiere repartir tarjetas de fidelización a sus clientes. 

	Si cada euro gastado equivale a 10 puntos y el sushi tiene un multiplicador de x2 puntos, 
	
	¿Cuántos puntos tendría cada cliente?

	*/


select
    y.customer_id,
    isnull(SUM(x.points),0) as total_points
from (
    select 
        a.customer_id,
        a.product_id,
        b.price as price,
        case 
            when b.product_name = 'sushi' then b.price * 20 
            else b.price * 10 
        end as points
    from [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] a
    LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] b on a.product_id = b.product_id
) x
RIGHT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[customers] y on y.customer_id = x.customer_id 
group by y.customer_id
order by total_points desc
;


