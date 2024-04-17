
SELECT
  CUSTOMERS.CUSTOMER_ID 
  , SUM(COALESCE(MENU.PRICE,0)) AS TOTAL
FROM SQL_EN_LLAMAS_ALUMNOS.case01.customers CUSTOMERS
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.sales SALES
  ON CUSTOMERS.CUSTOMER_ID = SALES.CUSTOMER_ID
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.case01.menu MENU
  ON MENU.PRODUCT_ID = SALES.PRODUCT_ID
GROUP BY CUSTOMERS.CUSTOMER_ID;

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien visto el cliente que no ha realizado ningún gasto en el restaurante.
Legibilidad: OK. Esto es más subjetivo, pero a mí me gusta como has presentado el ejercicio.

Además, me ha gustado que nombres las columnas y limpies los valores nulls antes de realizar la suma. ¡Enhorabuena!
*/
