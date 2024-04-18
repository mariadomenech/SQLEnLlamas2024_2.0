WITH PrimerasVentas AS (
    SELECT 
    DISTINCT    customer_id,
        MIN(order_date) AS primera_venta_date
    FROM 
        [case01].[sales]
    GROUP BY 
        customer_id
)

SELECT 
   DISTINCT c.customer_id,
    COALESCE(FIRST_VALUE(m.product_name) OVER (PARTITION BY c.customer_id ORDER BY pv.primera_venta_date), '0') AS primer_producto
FROM 
    [case01].[customers] c
LEFT JOIN 
    PrimerasVentas pv ON c.customer_id = pv.customer_id
LEFT JOIN 
    [case01].[sales] s ON c.customer_id = s.customer_id AND pv.primera_venta_date = s.order_date
LEFT JOIN 
    [case01].[menu] m ON s.product_id = m.product_id;
