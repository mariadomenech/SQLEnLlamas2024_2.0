/* Alumno: Sergio Díaz */
/* CASO 4 - Ejercicio 2: Combinación de más de 3 productos más repetida */

WITH transacciones_validas AS ( -- CTE para obtener las transacciones de más de un producto distinto
SELECT txn_id, COUNT(DISTINCT prod_id) AS n_prod
FROM case04.sales
GROUP BY txn_id
having COUNT (DISTINCT prod_id) > 2
)

, lista_prod AS ( --CTE para obtener la lista de productos de cada transacción en un único registro
SELECT dist.txn_id, 
CONCAT('La combinaciON más repetida es: ',CHAR(13), STRING_AGG(CONCAT('- ', dist.product_name), CHAR(13)) WITHIN GROUP (ORDER BY dist.product_name ASC)) AS prod_list --Mensaje con los nombres de los productos por transaccion ordenados alfabéticamente
FROM (SELECT DISTINCT txn_id, det.product_name
FROM case04.sales sales JOIN case04.product_details det
ON sales.prod_id = det.product_id) dist
GROUP BY dist.txn_id
)

SELECT top 1  COUNT(l.prod_list) AS N_VECES_COMBINACION, l.prod_list AS DESC_COMBINACION --Nos quedamos con el primer registro con más repeticiones
FROM transaccinees_validas t
JOIN lista_prod l
ON t.txn_id = l.txn_id
GROUP BY l.prod_list
ORDER BY COUNT(l.prod_list) DESC;
