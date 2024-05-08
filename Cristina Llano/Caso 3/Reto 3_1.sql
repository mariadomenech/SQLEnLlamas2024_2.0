-- ¿En cuántos días de media se reasignan los clientes a un nodo diferente?
WITH BASE_FECHAS_NULOS AS(
	SELECT 	
		/*Comprueba si un grupo ANTERIOR es distinto, en LAG ponemos valor por defecto 0 por si es el primero y no devuelva nulo porque no tiene con que comparar*/
		CASE  WHEN (grupos <> LAG(grupos,1,0) OVER(ORDER BY customer_id,  start_date)) 
			    AND 
			    ( 	(grupos = LEAD(grupos) OVER(ORDER BY customer_id, node_id, start_date)) /*Si el grupo POSTERIOR es igual */
				    OR
				      (grupos <> LEAD(grupos,1,0) OVER(ORDER BY customer_id, node_id, start_date)) /*Si el grupo POSTERIOR diferente y mantemos ese tramo*/
			    ) 
			    THEN start_date END AS fecha_primero
		, CASE WHEN (grupos <> LEAD(grupos,1,0) OVER(ORDER BY customer_id, start_date)) 
			     AND 
			      (	  (grupos = LAG(grupos) OVER(ORDER BY customer_id, node_id, start_date)) /*Si el grupo ANTERIOR es igual*/
				      OR
				        (grupos <> LAG(grupos,1,0) OVER(ORDER BY customer_id, node_id, start_date)) /*Si el grupo ANTERIOR es distinto*/
			      )
			      THEN end_date END AS fecha_ultimo
		, base.*
	FROM 
	(
		SELECT DENSE_RANK () OVER(ORDER BY customer_id, node_id) AS grupos
			, customer_id
			, node_id
			, start_date
			, end_date
		FROM SQL_EN_LLAMAS_ALUMNOS.case03.customer_nodes
	) base
),

BASE_FECHAS_DUPLI AS (
	SELECT DISTINCT customer_id
		, CAST (CASE  WHEN (fecha_primero IS NULL AND fecha_ultimo IS NULL) THEN start_date 
				          WHEN (fecha_primero IS NOT NULL) THEN fecha_primero
				          WHEN (fecha_primero IS NULL AND fecha_ultimo IS NOT NULL) THEN LAG(start_date) OVER(ORDER BY customer_id, node_id, start_date, grupos)
				    END AS DATE) AS fecha_inicio_vigencia 
		,CAST (CASE	WHEN (fecha_primero IS NULL AND fecha_ultimo IS NULL) THEN end_date 
					      WHEN (fecha_ultimo IS NOT NULL) THEN fecha_ultimo
					      WHEN (fecha_ultimo IS NULL AND fecha_primero IS NOT NULL) THEN LEAD(end_date) OVER(ORDER BY customer_id, node_id, start_date, grupos)
				    END AS DATE) AS fecha_fin_vigencia 
	FROM BASE_FECHAS_NULOS
	WHERE -- Nos quitamos tramos entremedias
	  (fecha_primero is null and fecha_ultimo is not null)
	  or (fecha_primero is not null and fecha_ultimo is null)
	  or (fecha_primero is not null and fecha_ultimo is not null)
)
SELECT CAST(ROUND(AVG (DATEDIFF (DAY, fecha_inicio_vigencia, fecha_fin_vigencia)*1.00),2) AS DECIMAL(5,2)) AS num_diferencia_dias
	, CONCAT('Los clientes se reasignan a un nodo diferente cada ', CAST (ROUND( AVG(DATEDIFF (DAY, fecha_inicio_vigencia, fecha_fin_vigencia)*1.00),2) AS DECIMAL(5,2)), ' días de media' ) des_dias_medias
FROM BASE_FECHAS_DUPLI
WHERE fecha_fin_vigencia <> '9999-12-31' /*No se tiene en cuenta los que están vigente ya que aún no han cambiado*/
;
-- Creo que se podría optimizar, pero no tengo mucho más tiempo para ello :(, de esta forma me he asegurado que contempla todos los casos.
