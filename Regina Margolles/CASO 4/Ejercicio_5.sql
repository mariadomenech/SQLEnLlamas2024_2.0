CREATE OR ALTER FUNCTION RMC_Caso4_Ejercicio_5 
(
@cat_id int,
@seg_id int
)
returns table
as
return
    (
	select product_name, cantidad_vendida
	from(
		select SUM(qty) over (partition by prod_id) as cantidad_vendida,
			   product_name,
			   ROW_NUMBER() over (order by prod_id) as row
		from
		(
				select prod_id,
					   qty,
					   product_name,
					   category_id,segment_id
				from(
					select distinct * from case04.SALES
				)as t
		left join case04.product_details as d
			on prod_id = d.product_id
		where category_id = @cat_id and segment_id = @seg_id
		)as t2

	)as t3
	where row= 1
	);
go




/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Tienes que revisarme bien el código, en concreto cuando sacas el producto más vendido por medio del ROW_NUMBER, no deberías ordernar por prod_id, 
sino por la suma de cantidad vendida. Te recomiendo usar RANK() en vez de ROW_NUMBER(), para sacar todos los productos posibles en caso de empate.

Reinténtalo :)

*/
