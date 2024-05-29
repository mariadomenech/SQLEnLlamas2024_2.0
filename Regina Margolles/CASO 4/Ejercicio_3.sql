with cte1
  as
  (
    	Select
          id as category_id,
      	  level_text as category_name
    	from case04.product_hierarchy
    	where parent_id is null
   ),
  cte2
  as
  ( 
    Select
      	category_id as category_id,
      	id as segment_id,
      	category_name,
      	level_text as segment_name
	from cte1 as c
	left join case04.product_hierarchy as h
	  on c.category_id = h.parent_id
   ),
   
   cte3
   as
   (
    Select
      	category_id,
      	segment_id,
      	h2.id as style_id,
      	category_name,
      	segment_name,
      	level_text as style_name
	from cte2 as c2
	left join case04.product_hierarchy as h2
	  on c2.segment_id = h2.parent_id
	
   ),
   cte4
   as
   (
   Select
        CONCAT(style_name,' ',(CONCAT(segment_name,' - ',category_name))) as product_name,
      	category_id,
      	segment_id,
      	style_id,
      	category_name,
      	segment_name,
      	style_name
	  from cte3 
   ),
   cte5
   as
   (
   Select
        p.product_id,
      	p.price,
        product_name,
      	category_id,
      	segment_id,
      	style_id,
      	category_name,
      	segment_name,
      	style_name
	from cte4 as c
	inner join case04.product_prices as p
	  on c.style_id = p.id
   )
select * from cte5;
