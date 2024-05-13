WITH ReassignmentDays AS (
    SELECT 
        CASE WHEN customer_id = usuario_anterior THEN 
            DATEDIFF(DAY, 
                     CASE WHEN fecha_anterior > GETDATE() THEN GETDATE() 
                          ELSE fecha_anterior 
                     END,
                     a.start_date
            ) - 1 
        END AS dias_nodo
    FROM (
        SELECT 
            A.*,
            LAG(a.start_date, 1) OVER (ORDER BY a.customer_id, a.start_date) AS fecha_anterior
        FROM (
            SELECT 
                t.*,
                LAG(t.node_id, 1, 0) OVER (ORDER BY t.customer_id, t.start_date) AS nodo_anterior,
                LAG(t.customer_id, 1) OVER (ORDER BY t.customer_id, t.start_date) AS usuario_anterior
            FROM 
                [case03].[customer_nodes] t
        ) a
        WHERE 
            node_id <> nodo_anterior OR customer_id <> usuario_anterior
    ) a
)

SELECT 
    CAST(CAST(SUM(dias_nodo) AS DECIMAL(16,2)) / SUM(CASE WHEN dias_nodo IS NOT NULL THEN 1 END) AS DECIMAL(16,2)) AS dias_reasignacion_media,
    'Los clientes se reasignan a un nodo diferente cada ' + 
        CAST(CAST(CAST(SUM(dias_nodo) AS DECIMAL(16,2)) / SUM(CASE WHEN dias_nodo IS NOT NULL THEN 1 END) AS DECIMAL(16,2)) AS VARCHAR(80))
        + ' días de media.' AS texto
FROM 
    ReassignmentDays;
