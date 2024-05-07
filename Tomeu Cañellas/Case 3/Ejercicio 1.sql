--CASO 3: Ejercicio 1
--Creamos una primera tabla temporal para obtener la fecha del final de la estancia previa en un mismo nodo, más adelante, usaremos esto
--para deshacernos de estancias continuas en un nodo registradas en diferentes filas
WITH continuous_periods AS (
    SELECT  customer_id,
            node_id,
            start_date,
            end_date,
            LAG(end_date) OVER (PARTITION BY customer_id, node_id ORDER BY start_date) AS prev_end_date --Obtenemos el end_date previo
    FROM [SQL_EN_LLAMAS_ALUMNOS].[case03].[customer_nodes]
	  WHERE end_date < '9999-12-31' --Filtramos las estancias activas en los nodos
),

--En esta tabla temporal marcamos con 0 si la start_date es igual a la end_date previa + 1, lo que significa que el periodo es continuo y con 1 si
--es el inicio de un periodo no continuo
marked_periods AS (
    SELECT  customer_id,
            node_id,
            start_date,
            end_date,
            CASE WHEN start_date = DATEADD(day, 1, prev_end_date) THEN 0
                 ELSE 1 END AS is_start_of_period --Indica si es inicio de periodo
    FROM continuous_periods
),

--Agrupamos los periodos
grouped_periods AS (
    SELECT  customer_id,
            node_id,
            start_date,
            end_date,
            SUM(is_start_of_period) OVER (PARTITION BY customer_id, node_id ORDER BY start_date) AS period_group
    FROM marked_periods
),


--Obtenemos la fecha mínima y la máxima para cada periodo continuo
intermediate_table AS (
	  SELECT  customer_id,
		        node_id,
		        MIN(start_date) AS start_date,
		        MAX(end_date) AS end_date,
		        period_group
	  FROM grouped_periods
	  GROUP BY customer_id, node_id, period_group
)

--Finalmente, calculamos la duración media en dias de cada estancia en un nodo
SELECT ROUND(
            AVG(
                CAST(
                    DATEDIFF(DAY, start_date, end_date) AS FLOAT
                        )
                    )
                , 2) AS avg_node_period FROM intermediate_table
;
