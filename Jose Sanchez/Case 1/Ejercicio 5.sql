WITH CTE as (
        SELECT
                sales.customer_id,
                points = CASE
                        menu.product_id
                        WHEN 1 THEN menu.price * 20
                        ELSE menu.price * 10
                END
        FROM
                case01.menu as menu
                LEFT JOIN case01.sales as sales ON menu.product_id = sales.product_id
)
SELECT
        customers.customer_id,
        SUM(ISNULL(points, 0)) as points
FROM
        case01.customers as customers
        LEFT JOIN CTE ON CTE.customer_id = customers.customer_id
GROUP BY
        customers.customer_id;

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*
RESULTADO: Correcto
CÓDIGO: Correcto --> No sabía yo que se podía hacer ese "=" en el select, pero algo que he aprendido hoy jeje.
                        No obstante, creo que sería mejor que si durante todo el código usas "as", mantengas ese formato.
LEGIBILIDAD: Correcta

Perfecto Jose!!!

*/
