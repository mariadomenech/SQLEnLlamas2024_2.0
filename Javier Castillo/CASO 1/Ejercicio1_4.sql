SELECT TOP 1
M.product_name
, COUNT(1) AS NUM_PEDIDOS
FROM [SQL_EN_LLAMAS_ALUMNOS].[case01].[sales] AS S
LEFT JOIN [SQL_EN_LLAMAS_ALUMNOS].[case01].[menu] AS M
	ON S.product_id=M.product_id
GROUP BY M.product_name
ORDER BY NUM_PEDIDOS DESC;

/*
Corrección Pablo: Si bien es cierto que obtienes el resultado correcto para este ejercicio, al usar TOP 1 estás devolviendo el primer registro 
únicamente y esto no sería correcto en caso de empate.

Resultado: OK. Obtienes el producto más demandado y cuántas veces se ha pedido.
Código: NOK. Para haber tenido en cuenta los empates, deberías haber añadido al TOP 1 el parámetro WITH TIES
(que siempre tiene que ir acompañado de un ORDER BY), o haber empleado la función de ventana RANK() o DENSE_RANK() que sí tienen en cuenta las 
situaciones de empate.
Legibilidad: OK. El código es perfectamente legible, aunque podrías haber tabulado las columnas del SELECT.

Te animo a que me comentes cualquier duda que te surja.
*/
