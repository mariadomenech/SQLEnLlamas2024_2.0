SELECT
    TOP(1) menu.product_name,
    COUNT(sales.product_id) as units_sold
from
    case01.menu as menu
    LEFT JOIN case01.sales as sales ON menu.product_id = sales.product_id
GROUP BY
    sales.product_id,
    menu.product_name
ORDER BY
    units_sold DESC;
