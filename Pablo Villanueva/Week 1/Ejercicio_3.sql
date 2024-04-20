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


/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*
La solución al ejercicio y por tanto el código del mismo no es correcta del todo. La idea es buena
y me gusta la creación de la CTE para quedarte con la fecha mínima de pedido de cada cliente.

Sin embargo, no es correcta ya que al usar FIRST_VALUE como función ventana te estás quedando únicamente con el
primer valor encontrado, pero no se está teniendo en cuenta empates y es que el cliente A en la misma fecha (fecha mínima)
pidió 2 productos distintos. 

La idea de este ejercicio era usar un RANK O DENSE_RANK y el STRING_AGG para agrupar distintos productos en una lista
y así sea más limpia la salida.

Échale un vistazo y cualquier cosa puedes preguntar sin problema.
Además te recomiendo echarle un vistazo a la app de streamlit https://sqlonfire.civica-soft.com/
para comparar tu resultado con el esperado :).

*/
