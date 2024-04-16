SELECT  
    c.customer_id,
    COUNT(DISTINCT s.order_date) AS total_visitas --no es necesario COALESCE porque COUNT ya devuelve valor 0 en lugar de NULL
FROM 
    case01.customers c
    LEFT JOIN case01.sales s
        ON c.customer_id = s.customer_id
GROUP BY 
    c.customer_id;



/********************************************/
/************COMENTARIO DANI*****************/
/********************************************/
/*Resultado correcto, buena legibilidad y buen manejo del DISTINCT para evitar que nos aparezca el mismo día repetidas veces,
todo correcto, sigue así Ismael! Te animo a que busques formas originales pero no demasiado complejas para obtener el mismo
resultado!*/
