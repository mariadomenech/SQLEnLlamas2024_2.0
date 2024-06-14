select  repitions as NUM_VECES_REPETIDA,
        ('La combinacion mas repetida es: ') + (STRING_AGG(d.product_name,' - ')) AS DESC_COMBINACION
from
          (
          select top(1) t3.list as list,
                        count(list) as repitions
          from
          (
                    select  t2.txn_id,
                            STRING_AGG(t2.prod_id,',') within group (order by prod_id asc) as list
                    from 
                    (
                                        select t.txn_id,
                                               t.prod_id, 
                                               COUNT(t.prod_id) over (partition by t.txn_id) as product_number
                                              from 
                                              (
                                                 select  distinct(prod_id),
                                                         txn_id
                                                 from case04.sales
                                                 group by txn_id, prod_id
                                               ) as t
                    ) as t2
                    where product_number > 2
                    group by txn_id
          )as t3
          group by list
          having count(list) > 1
          order by repitions desc
)as t4
cross apply string_split (t4.list,',') 
left join case04.product_details as d
    on value=d.product_id
group by repitions;



/*********************************************************/
/***************** COMENTARIO MARÍA **********************/
/*********************************************************/
/*

Nice!

Resultado: OK
Código: OK. 
Legibilidad: OK.


*/
