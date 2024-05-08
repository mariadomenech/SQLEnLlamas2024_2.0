SELECT
	cast (cast(sum(dias_nodo) as decimal(16,2))/ sum( case when dias_nodo is not null then 1 end) as decimal(16,2)) as dias_media
	, 'Los clientes se reasignan a un nodo diferente cada ' + 
		cast (cast (cast(sum(dias_nodo) as decimal(16,2))/ sum( case when dias_nodo is not null then 1 end) as decimal(16,2)) as varchar(80))
		+ ' días de media.' as texto
FROM
(
select 
		case when customer_id= usuario_anterior then 
			datediff(day, 
					case when 
						fecha_anterior>getdate() then getdate() 
					else
						fecha_anterior 
					end
					,a.start_date
			)
			end -1 as dias_nodo	
	from
	(
	select A.*
	, lag(a.start_date, 1)OVER (ORDER BY a.customer_id, a.start_date) as fecha_anterior
	from
	(
		SELECT 
			t.*
			, lag(T.node_id, 1, 0) OVER (ORDER BY t.customer_id, T.start_date)as  nodo_anterior
			, lag(t.customer_id, 1)OVER (ORDER BY t.customer_id, t.start_date) as usuario_anterior	

		FROM 
			[case03].[customer_nodes] t
		
	)a
	where node_id <> nodo_anterior or customer_id <> usuario_anterior
	)A
)A;
