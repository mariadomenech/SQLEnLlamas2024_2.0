WITH CTE as (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY
                order_date ASC
        ) AS row_number
    FROM
        case01.sales
)
SELECT
    customers.customer_id,
    menu.product_name,
    sales.order_date
FROM
    case01.customers as customers
    LEFT JOIN CTE as sales ON customers.customer_id = sales.customer_id
    LEFT JOIN case01.menu as menu ON menu.product_id = sales.product_id
WHERE
    sales.row_number = 1
