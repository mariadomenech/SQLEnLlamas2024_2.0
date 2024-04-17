WITH RankedOrders AS (
    SELECT s.CUSTOMER_ID, m.PRODUCT_NAME,
           RANK() OVER(PARTITION BY s.CUSTOMER_ID ORDER BY s.ORDER_DATE) as rn
    FROM case01.sales s
    JOIN case01.menu m ON s.PRODUCT_ID = m.PRODUCT_ID
),
DistinctOrders AS (
    SELECT DISTINCT CUSTOMER_ID, PRODUCT_NAME
    FROM RankedOrders
    WHERE rn = 1
),
GroupedOrders AS (
    SELECT CUSTOMER_ID, STRING_AGG(PRODUCT_NAME, ', ') WITHIN GROUP (ORDER BY PRODUCT_NAME) as Products
    FROM DistinctOrders
    GROUP BY CUSTOMER_ID
)
SELECT c.CUSTOMER_ID, COALESCE(g.Products, 'sin pedido') AS Primer_Producto_Pedido
FROM case01.customers c
LEFT JOIN GroupedOrders g ON c.CUSTOMER_ID = g.CUSTOMER_ID
ORDER BY c.CUSTOMER_ID;



/*************************************/
/********COMENTARIO DANI**************/
/*************************************/
/* Resultado correcto, me ha gustado el enfoque al usar STRING_AGG y WITHIN GROUP para obtener el resultado concatenado
y solo uno por cliente. Mejoraría la legibilidad del código indentando los atributos y como consejo te recomendaría
usar alias mas fáciles de interpretar, pero esto último ya es gusto propio, siempre que esté bien documentado
el alias no debería ser tan determinante. En cuanto a lo mencionado anteriormente, la legibilidad la mejoraría algo así

WITH RankedOrders AS (
    SELECT	s.CUSTOMER_ID, 
		m.PRODUCT_NAME,
		RANK() OVER(PARTITION BY s.CUSTOMER_ID ORDER BY s.ORDER_DATE) as rn
    FROM SQL_EN_LLAMAS.case01.sales s
	JOIN SQL_EN_LLAMAS.case01.menu m 
		ON s.PRODUCT_ID = m.PRODUCT_ID
),

DistinctOrders AS (
    SELECT DISTINCT	CUSTOMER_ID,
			PRODUCT_NAME
    FROM RankedOrders
    WHERE rn = 1
),

GroupedOrders AS (
    SELECT	CUSTOMER_ID, 
		STRING_AGG(PRODUCT_NAME, ', ') WITHIN GROUP (ORDER BY PRODUCT_NAME) as Products
    FROM DistinctOrders
    GROUP BY CUSTOMER_ID
)
SELECT	c.CUSTOMER_ID,
	COALESCE(g.Products, 'SIN PEDIDO') AS Primer_Producto_Pedido
FROM SQL_EN_LLAMAS.case01.customers c
LEFT JOIN GroupedOrders g 
	ON c.CUSTOMER_ID = g.CUSTOMER_ID
ORDER BY c.CUSTOMER_ID;
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
Te añado un ejemplo de como sería obtener los mismos resultados sin necesidad de tantas CTE`s:

WITH PrimerPedido AS (
    SELECT customer_id, 
    MIN(order_date) as PrimerFecha
    FROM SQL_EN_LLAMAS.CASE01.SALES
    GROUP BY customer_id
)

SELECT  members.customer_id ,
        LISTAGG(distinct COALESCE(menu.product_name, 'No ha hecho pedidos'), ',') as product_name
FROM SQL_EN_LLAMAS.CASE01.CUSTOMERS
LEFT JOIN PrimerPedido pp 
    ON customers.customer_id = pp.customer_id
LEFT JOIN SQL_EN_LLAMAS.CASE01.SALES 
    ON customers.customer_id = sales.customer_id
    AND pp.PrimerFecha = sales.order_date
LEFT JOIN SQL_EN_LLAMAS.CASE01.MENU 
    ON sales.product_id = menu.product_id;
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
Ánimo Ismael! Este es el camino!*/
