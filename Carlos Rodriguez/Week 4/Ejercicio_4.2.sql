
WITH TransactionCombinations AS (
    SELECT 
        s.txn_id,
        STRING_AGG(CAST(pd.product_name AS VARCHAR(MAX)), ', ') WITHIN GROUP (ORDER BY pd.product_name) AS combined_products
    FROM 
        case04.sales s
    INNER JOIN 
        case04.product_details pd ON s.prod_id = pd.product_id
    GROUP BY 
        s.txn_id
    HAVING 
        COUNT(DISTINCT s.prod_id) >= 3
),
MostFrequentCombination AS (
    SELECT 
        combined_products,
        COUNT(*) AS transaction_count
    FROM 
        TransactionCombinations
    GROUP BY 
        combined_products
)
SELECT 
    TOP 1
    FORMAT(transaction_count, 'N0') AS Num_Veces_Repetida,
    combined_products AS Desc_Combinacion
FROM 
    MostFrequentCombination
ORDER BY 
    transaction_count DESC;

/*********************************************************/
/***************** COMENTARIO ÁNGEL *********************/
/*********************************************************/
/*

Correcto! Como observación, intenta no meter tantos saltos de linea despues de FROMs, GROUP BYs, etc.. Hace la lectura un poco mas tediosa

*/
