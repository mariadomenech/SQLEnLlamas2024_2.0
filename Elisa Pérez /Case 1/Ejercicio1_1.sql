select S.customer_id, sum(M.price) total_price
from [case01].[sales] S
join [case01].[menu] M
on S.product_id = M.product_id
group by S.customer_id;
