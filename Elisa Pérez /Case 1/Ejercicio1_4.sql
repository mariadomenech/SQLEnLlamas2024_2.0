SELECT 
  TOP 1 M.product_name
  , COUNT(S.product_id) total
FROM case01.sales S
LEFT JOIN case01.menu M
  ON S.product_id = M.product_id
GROUP BY M.product_name
ORDER BY total DESC


/**************************************/
/********COMENTARIO DANI***************/
/**************************************/
/* Resultado correcto, legibilidad impoluta y atajas con un TOP 1, me gusta el enfoque
Elisa!.Te animo a buscar alternativas al uso del TOP, como una función de ventana RANK.
Ánimo y sigue así, este es el camino!*/
