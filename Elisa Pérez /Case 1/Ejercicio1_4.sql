SELECT 
  TOP 1 M.product_name
  , COUNT(S.product_id) total
FROM case01.sales S
LEFT JOIN case01.menu M
  ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY total DESC
