SELECT 
    c.CUSTOMER_ID,
    COALESCE(SUM(CASE WHEN m.PRODUCT_NAME = 'sushi' THEN m.PRICE * 20 ELSE m.PRICE * 10 END), 0) AS PUNTOS
FROM 
    case01.customers c
LEFT JOIN 
    case01.sales s ON c.CUSTOMER_ID = s.CUSTOMER_ID
LEFT JOIN 
    case01.menu m ON m.PRODUCT_ID = s.PRODUCT_ID
GROUP BY 
    c.CUSTOMER_ID;


/***********************************/
/********COMENTARIO DANI************/
/***********************************/
/* Resultado correcto, buen manejo de nulos usando COALESCE, buen manejo de lógica,
sin embargo mejoraría un poco la legibilidad. Ten en cuenta que cuando hacemos
varios agregados o directamente seleccionamos varios atributos en la misma línea 
dificultamos la interpretación y lectura del código y eso nos puede presentar 
problemas a la hora de detectar posibles errores, aunque sean sintácticos. 
Te animo a usar IFF en casos de casuísticas sencillas, CASE lo podemos usar a la
hora tener diferentes condicionantes o una única casuística mas compleja. 
Ánimo Ismael, sé que puedes, a por todas!*/
