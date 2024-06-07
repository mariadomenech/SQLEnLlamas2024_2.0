-- Calcula los ingresos netos pOR transacción
WITH IngresosPorTransacciON AS (
SELECT 
 txn_id,
        
 SUM(price * qty) AS ingresos_brutos,
        
 SUM(price * discount * 0.01 * qty) AS descuento,
        
 SUM(price * qty) - SUM(price * discount * 0.01 * qty) AS ingresos_netos

    FROM 
 (SELECT DISTINCT *
    FROM case04.sales) AS ventas

    GROUP BY  
 txn_id
)

-- Calcula los percentiles continuos y discretos de los ingresos netos
SELECT DISTINCT
 'CONTINUO' AS tipo_percentil,
        
 PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_25,
 PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_50,
 PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_75
FROM 
 IngresosPorTransaccion

UNION ALL

SELECT DISTINCT
 'DISCRETO' AS tipo_percentil,
        
 PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_25,
 PERCENTILE_DISC(0.50) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_50,
 PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY ingresos_netos)
    OVER () AS percentile_75
FROM 
 IngresosPorTransaccion
ORDER BY 
 tipo_percentil;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Correcto!

*/
