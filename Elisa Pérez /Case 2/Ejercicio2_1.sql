WITH tmp AS(
	SELECT	O.order_id
			    , R.runner_id
			    , CAST(IIF(O.distance='null', NULL,REPLACE(O.distance, 'km', ''))AS decimal(4,2)) distance
			    , CAST(IIF(O.duration='null', NULL, TRIM('minutes ' FROM O.duration))AS decimal(4,2)) duration
	FROM case02.runner_orders O
	RIGHT JOIN case02.runners R
	ON O.runner_id = R.runner_id
)
SELECT	runner_id
		    , ISNULL(SUM(distance), 0) distancia_acum
		    , ISNULL(CAST(AVG(distance/duration)AS decimal(4,2)), 0)  velocidad_avg
FROM tmp
GROUP BY runner_id;


/********************************************/
/**********COMENTARIO DANI*******************/
/********************************************/
/* Resultado parcialmente incorrecto, has estado muy muy cerquita, te explico. El resultset 
que nos devuelve tu consulta no calcula bien la velocidad media, el resultado es demasiado
bajo, ¿donde está el problema?, pues bien en la línea ..."ISNULL(CAST(AVG(distance/duration)AS decimal(4,2)), 0)  velocidad_avg"
calculamos la velocidad media dividiendo la distancia entre la duración, sin embargo, la duración está 
expresada en minutos mientras que la distancia en Kilómetros, primero deberíamos convertir la duración
a horas para posteriormente hacer la división. Por otra parte me ha gustado el enfoque de usar CTE,
la legibilidad es cada día mas impecable, Enhorabuena Elisa! y también destacar que has tenido en cuenta
el control de NULLS. Te animo a que le des una vueltita (te chivo que no es difícil) y me pongas la corrección 
abajo de este comentario!. Ánimo Elisa, a por todas!*/



WITH tmp AS(
	SELECT	O.order_id
		, R.runner_id
		, CAST(IIF(O.distance='null', NULL,REPLACE(O.distance, 'km', ''))AS decimal(4,2)) distance
		, CAST(IIF(O.duration='null', NULL, TRIM('minutes ' FROM O.duration))AS decimal(4,2)) duration
	FROM case02.runner_orders O
	RIGHT JOIN case02.runners R
	ON O.runner_id = R.runner_id
)
SELECT	runner_id
		, ISNULL(SUM(distance), 0) distancia_acum
		, ISNULL(CAST(AVG(distance/(duration/60))AS decimal(4,2)), 0)  velocidad_avg
FROM tmp
GROUP BY runner_id;
