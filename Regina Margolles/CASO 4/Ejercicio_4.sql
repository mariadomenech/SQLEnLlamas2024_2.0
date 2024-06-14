select  distinct
		'Continuo' as Tipo_de_percentil,
		 PERCENTILE_CONT(0.25) within group(order by benefit) over () as percentile_25,
		 PERCENTILE_CONT(0.50) within group(order by benefit) over () as percentile_50,
		 PERCENTILE_CONT(0.75) within group(order by benefit) over () as percentile_75 
from(
		select  SUM(qty * (price - (price * discount * 0.01))) as benefit,
				    txn_id 
		from(
				select distinct * 
				from case04.sales
			) as t
		group by txn_id
		)as t2

UNION

Select 'Discreto' as Tipo_de_percentil,
		 PERCENTILE_DISC(0.25) within group(order by benefit) over () as percentile_disc_25,
		 PERCENTILE_DISC(0.50) within group(order by benefit) over () as percentile_disc_50,
		 PERCENTILE_DISC(0.75) within group(order by benefit) over () as percentile_disc_75
from(
		select  SUM(qty * (price - (price * discount * 0.01))) as benefit,
				    txn_id 
		from(
				select distinct * 
				from case04.sales
			) as t
		group by txn_id
		)as t2;
/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

perfecto! Si no habías trabajado antes con percentiles, esperto que te haya servido de ayuda.

Código: OK
Legibilidad: Un poco mejorable.
Resultado: OK
*/
