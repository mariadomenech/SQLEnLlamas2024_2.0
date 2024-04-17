SELECT
   CUSTOMERS.CUSTOMER_ID AS ID_CLIENTE
   , COUNT (DISTINCT SALES.ORDER_DATE) AS NUM_VISITAS
FROM SQL_EN_LLAMAS_ALUMNOS.CASE01.CUSTOMERS CUSTOMERS
LEFT JOIN SQL_EN_LLAMAS_ALUMNOS.CASE01.SALES SALES
  ON CUSTOMERS.CUSTOMER_ID = SALES.CUSTOMER_ID
GROUP BY CUSTOMERS.CUSTOMER_ID
ORDER BY NUM_VISITAS DESC;      // se utiliza para mostrar un ranking de los clientes con más visitas

/*
Corrección Pablo: Todo perfecto.

Resultado: OK. Obtienes justo lo que se pedía.
Código: OK. Bien aplicado el COUNT DISTINCT.
Legibilidad: OK. Esto es más subjetivo, pero a mí me gusta como has presentado el ejercicio.

Además, me ha gustado que ordenes la salida. ¡Enhorabuena!
*/
