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
