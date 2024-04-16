SELECT
  customers.customer_id,
  ISNULL(COUNT(sales_per_day), 0) as total_visits
FROM
  case01.customers as customers
  LEFT JOIN (
    SELECT
      customer_id,
      order_date,
      COUNT(order_date) as sales_per_day
    FROM
      case01.sales
    GROUP BY
      customer_id,
      order_date
  ) as sales ON sales.customer_id = customers.customer_id
GROUP BY
  customers.customer_id;
