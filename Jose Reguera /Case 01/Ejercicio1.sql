select B.customer_id as NombreCliente ,
	Isnull(sum(C.price),0) as Dinero_Gastado 

from case01.sales A

  full outer join case01.customers B
	 on A.customer_id=B.customer_id
  full outer join case01.menu C
	 on A.product_id=C.product_id

	 group by B.customer_id;
