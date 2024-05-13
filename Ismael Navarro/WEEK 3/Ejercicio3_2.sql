WITH TempTransactions AS (
    SELECT 
        customer_id,
        YEAR(txn_date) AS Year,
        MONTH(txn_date) AS Month,
--hago "case when" para contar  como 1 cada tipo para los pasos siguientes
        CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END AS Deposit,
        CASE WHEN txn_type = 'withdrawal' THEN 1 ELSE 0 END AS Withdrawal,
        CASE WHEN txn_type = 'purchase' THEN 1 ELSE 0 END AS Purchase
    FROM case03.customer_transactions
),
AggregatedTransactions AS (
    SELECT 
        customer_id,
        Year,
        Month,
        SUM(Deposit) AS TotalDeposits,
        SUM(Withdrawal) AS TotalWithdrawals,
        SUM(Purchase) AS TotalPurchases
    FROM TempTransactions
    GROUP BY customer_id, Year, Month
)
SELECT 
    Year AS Año,
    Month AS Mes,
    COUNT(customer_id) AS TotalClientes
FROM AggregatedTransactions
WHERE (TotalDeposits > 1 AND TotalPurchases > 1) OR TotalWithdrawals > 1
GROUP BY Year, Month
ORDER BY MES;
