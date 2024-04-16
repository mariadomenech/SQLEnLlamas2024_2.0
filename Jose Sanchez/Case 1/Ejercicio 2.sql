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

/*********************************************************/
/***************** COMENTARIO IRENE **********************/
/*********************************************************/
/*

El resultado es correcto, pero se podría hacer más simple. Ahora mismo estás usando una subconsulta para
contar el número de compras por día. No obstante, no haría falta ese proceso intermedio. Podrías poner directamente:
SELECT
   customers.customer_id,
   COUNT(DISTINCT order_date) as total_visits
FROM
  case01.customers
  LEFT JOIN case01.sales 
ON sales.customer_id = customers.customer_id
GROUP BY
  customers.customer_id;

Te voy a dar feedback también de dos cosillas más:
--> a) Para hacer el código más legible utiliza las ctes:
        with cte as(
          SELECT
            customer_id,
            order_date,
            COUNT(order_date) as sales_per_day
          FROM
            case01.sales
          GROUP BY
            customer_id,
            order_date
        )
      
        SELECT
          customers.customer_id,
          ISNULL(COUNT(sales_per_day), 0) as total_visits
        FROM
          case01.customers as customers
          LEFT JOIN cte as sales
          ON sales.customer_id = customers.customer_id
        GROUP BY
          customers.customer_id;

--> b)sería mejor que pusieses:
	- COUNT(ISNULL(sales_per_day, 0)) as total_visits
	en vez de 
	- ISNULL(COUNT(sales_per_day), 0) as total_visits
  Primero comprobamos si hay nulos, y si los hay, los transformamos a 0 y luego ya los contamos. 
  En este caso no da error, pero en otras situaciones sumar números con un null puede dar un null como resultado.
  Ej: si pones en sql server "select 3+NULL+5;" sale como resultado NULL
  
  Para evitarnos problemas, mejor siempre comprobar primero si hay nulos y luego lo que queramos hacerle al número.

*/
