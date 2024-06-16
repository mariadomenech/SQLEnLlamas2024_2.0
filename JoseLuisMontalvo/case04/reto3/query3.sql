/*--- Crear una consulta que replique la tabla de products details . Hay que transformar los conjuntos de DATOS_PRODCUT_HERACHY y PRODUCT PRICES*/	
  select pp.product_id,
         pp.price,
		     ph.level_text+' '+ph2.level_text+' - '+ph3.level_text as product_name,
		     ph2.parent_id as category_id,
		     ph.parent_id as segment_id,
		     ph.id as style_id,ph3.level_text as category_name,
         ph2.level_text as segment_name,
		     ph.level_text as style_name 
	 from [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_prices] pp
              inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] ph on pp.id=ph.id
			        inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] ph2 on ph.parent_id=ph2.id
			        inner join [SQL_EN_LLAMAS_ALUMNOS].[case04].[product_hierarchy] ph3 on ph2.parent_id=ph3.id;



/*********************************************************/
/***************** COMENTARIO MANU **********************/
/*********************************************************/
/*

Correcto!

RESULTADO: OK.
CÓDIGO: OK.
LEGIBILIDAD: OK.

*/
