SELECT 
	customers.customer_id as Cliente,
	ISNULL(SUM(menu.price), 0) as Total_Gasto
FROM case01.customers customers
LEFT JOIN case01.sales sales
	ON customers.customer_id = sales.customer_id
LEFT JOIN case01.menu menu
	ON sales.product_id = menu.product_id
GROUP BY customers.customer_id
ORDER BY Total_Gasto DESC;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

Muy bien Jose, está correcto!!!

Una única cosa para comentarte, sería mejor que pusieses:
	- SUM(ISNULL(menu.price, 0)) as Total_Gasto 
	en vez de 
	- ISNULL(SUM(menu.price), 0) as Total_Gasto
Primero comprobamos si hay nulos, y si los hay, los transformamos a 0 y luego ya los sumamos. 
En este caso no da error, pero en otras situaciones sumar números con un null puede dar un null como resultado.
Ej: si pones en sql server "select 3+NULL+5;" sale como resultado NULL

Para evitarnos problemas, mejor siempre comprobar primero si hay nulos y luego lo que queramos hacerle al número.

*/
