select cust.customer_id as Cliente      
	   ,Isnull ( ( Select sum(men2.price) from case01.menu men2 
			                     inner join case01.sales sal2
					           on  sal2.product_id=men2.product_id and sal2.customer_id=cust.customer_id 
			      ),0 ) as Gastado
from case01.customers cust
order by 2 desc;
