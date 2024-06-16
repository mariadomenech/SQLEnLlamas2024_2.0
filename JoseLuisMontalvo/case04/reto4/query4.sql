/* Cuales son los valores, percentiles 25, 50, 75 para los ingresos por transacción.  */


/*Agrupamos en una temporal el total neto por cada transacción*/
with IngresosNetosTransaccion  as 
     (
	  select [txn_id],
	         SUM(qty * price - discount) as Total
      FROM [SQL_EN_LLAMAS_ALUMNOS].[case04].[sales]
	  group by [txn_id]	 
	 )
/*Obtenes los percentiles solicitados*/    
select distinct percentile_cont(0.25) WITHIN GROUP (ORDER BY Total) OVER () AS percentil_25,
                percentile_cont(0.50) WITHIN GROUP (ORDER BY Total) OVER () AS percentil_50,
                percentile_cont(0.75) WITHIN GROUP (ORDER BY Total) OVER () AS percentil_75
	   from IngresosNetosTransaccion 



/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

La lógica es totalmente correcta, sin embargo no se ha tenido en cuenta 
el control de duplicados en la tabla sales, por lo que el código no sería del todo correcto
pues le faltaría ese detalle.

*/
