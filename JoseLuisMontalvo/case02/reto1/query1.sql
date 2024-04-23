-- Reto 1-
/* Cual es la distancia acumulada de cada runner y la velocidad promedio en KM/H */

---- Tabla auxiliar para limpieza y cálculo de datos.
with Auxiliar as (
select runner_id,order_id,sum(
                      case 
                      when TRY_CAST(distance as decimal(10,2)) is null then cast(substring(distance,patindex('%[0-9.]%',distance),patindex('%[^0-9.]%',distance)-1) as decimal(10,2))
                      else TRY_CAST(distance as decimal(10,2))
                      end) as Distancia_Recorrida	,
			     avg( 
				     case 
                     when TRY_CAST(duration as decimal(10,2)) is null then cast(substring(duration,patindex('%[0-9.]%',duration),patindex('%[^0-9.]%',duration)-1) as decimal(10,2))
                     else TRY_CAST(duration as decimal(10,2))
                     end)/60 as Duracion_horas	
			from case02.runner_orders 
			where distance<>'null'
group by runner_id,order_id ) 

---- Resultado final
select runner.runner_id,
      isnull(sum(Distancia_Recorrida),0) as Distancia_total_Km,
	  isnull(cast(avg(Distancia_Recorrida/Duracion_horas) as decimal(10,2)),0) as Velocidad_Media_KmH
  from case02.runners runner
              left join Auxiliar aux on aux.runner_id=runner.runner_id
group by runner.runner_id;
