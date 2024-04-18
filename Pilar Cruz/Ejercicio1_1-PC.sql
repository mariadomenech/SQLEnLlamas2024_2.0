SELECT
	SALES.CUSTOMER_ID AS CUSTOMER,
	SUM(MENU.PRICE) AS PRICE
FROM
	(
		SELECT CUSTOMER_ID, PRODUCT_ID FROM SQL_EN_LLAMAS_ALUMNOS.case01.sales
	) SALES
	LEFT JOIN
	(
		SELECT PRICE, PRODUCT_ID FROM SQL_EN_LLAMAS_ALUMNOS.case01.menu
	) MENU
	ON SALES.PRODUCT_ID = MENU.PRODUCT_ID
GROUP BY SALES.CUSTOMER_ID;



/*********************************************************/
/***************** COMENTARIO MANU *********************/
/*********************************************************/
/*

El resultado no es del todo correcto y  por lo tanto el código tampoco lo es. Para que esté completamente correcto
se espera tener en cuanta al cliente D, aunque este no haya realizo ninguna compra. Para esto, en tu caso podrías hacer un RIGHT JOIN de case01.customers
y traerte a ese cliente también. Además para terminar de perfeccionar la query habría que hacer un tratamiento para los nulos para casos como el del cliente D,
en el que la suma del gasto sería NULL. Existen distintas funciones en SQL SERVER para conseguir esto, por ejemplo: isnull(sum(price),0) así si la suma es NULL devolvería 0.

Por otra parte, la legibilidad es correcta, aunque podría terminar de afinarse separando los campos de los select en la subconsultas, pero es muy subjetivo.

En resumen, te ha faltado ese detallito para que termine de estar correcto del todo, te animo a que le des una vuelta con lo que te comento y así puedas entenderlo mejor :).

Por último, te aconsejo, para que nos resulte menos lioso para ambos, el organizar los archivos de los retos por carpetas (CASE01,CASE02, etc.), ya que van a acabar siendo muchos
archivos y también usar una nomenclatura común para los distintos archivos.

Cualquier duda no dudes en preguntar que para eso estamos, ánimo y a por los siguientes!!!
*/
