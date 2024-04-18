WITH CTE as (
    SELECT
        customer_id,
        MIN(order_date) as order_date
    FROM
        case01.sales as sales
    GROUP BY
        sales.customer_id
),
CTE_first_sales as (
    SELECT
        sales.customer_id,
        menu.product_name
    from
        case01.sales as sales
        RIGHT JOIN CTE as first_sale ON sales.customer_id = first_sale.customer_id
        AND sales.order_date = first_sale.order_date
        RIGHT JOIN case01.menu as menu ON menu.product_id = sales.product_id
)
SELECT
    [customer_id],
    ISNULL(
        STUFF(
            (
                SELECT
                    DISTINCT ', ' + product_name
                FROM
                    CTE_first_sales as sales
                WHERE
                    customers.customer_id = sales.customer_id FOR XML PATH ('')
            ),
            1,
            1,
            ''
        ),
        ''
    ) AS products
from
    case01.customers as customers;


/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto
CÓDIGO: Correcto, un poco complejo, pero bien
LEGIBILIDAD: Correcta, gracias por usar las ctes!

Has utilizado una manera original para resolver el ejercicio. No sabía que existía la función de STUFF, así que gracias por enseñármela!

Te pongo aquí otra forma de solucionar el ejercicio:
WITH CTE AS(
    SELECT
        DISTINCT cu.customer_id customer_id,
        m.product_name, 
        s.order_date,
        RANK() OVER(PARTITION BY cu.customer_id ORDER BY s.order_date) AS SEQ
    FROM SQL_EN_LLAMAS.CASE01.CUSTOMERS cu
        LEFT JOIN CASE01.SALES s ON cu.customer_id = s.customer_id
        LEFT JOIN CASE01.MENU m ON s.product_id = m.product_id
) 
SELECT 
     customer_id,
     COALESCE(STRING_AGG(product_name, ', '),' ') AS "products"
FROM CTE
WHERE SEQ = 1
GROUP BY customer_id
ORDER BY customer_id;

*/
