select A.customer_id as NombreCliente ,
	Isnull(sum(C.price),0) as Dinero_Gastado 

from case01.customers A

  full outer join case01.sales B
	 on A.customer_id=B.customer_id
  full outer join case01.menu C
	 on B.product_id=C.product_id

	 group by A.customer_id;
