# Solutions
## Q.1 What is the total amount each customer spent at the restaurant?
````sql
SELECT 
    s.customer_id, SUM(m.price) AS Amount_Spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id
  ````
  
| customer_id | unique_customer_orders |
| ----------- | ---------------------- |
| A           | 76                     |
| B           | 74                     |
| C           | 36                     |

