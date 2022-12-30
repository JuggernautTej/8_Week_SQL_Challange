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
  
| customer_id | Amount_Spent           |
| ----------- | ---------------------- |
| A           | 76                     |
| B           | 74                     |
| C           | 36                     |

 ## Q2. How many days has each customer visited the restaurant?
 ````sql
 SELECT 
    customer_id,
    COUNT(DISTINCT order_date) AS No_of_Days_Visited
FROM
    sales
GROUP BY customer_id
  ````
  
| customer_id | No_of_Days_Visited     |
| ----------- | ---------------------- |
| A           | 4                      |
| B           | 6                      |
| C           | 2                      |

## Q3. What was the first item from the menu purchased by each customer?
````sql
SELECT 
    s.customer_id AS Customer,
    MIN(s.order_date) AS First_order_Date,
    m.product_name AS Item_Purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
  ````
  
| Customer | First_order_Date | Item_Purchased   |
| -------- | ---------------- | ---------------- |
| A        | 2021-01-01       | sushi            |
| B        | 2021-01-01       | curry            |
| C        | 2021-01-01       | ramen            |


## Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?
````sql
SELECT 
    A.product_name AS Item,
    A.no_of_occurrence AS no_of_times_purchased
FROM
    (SELECT 
        m.product_name as product_name, COUNT(s.product_id) AS no_of_occurrence
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id
    GROUP BY s.product_id) as A
    ORDER BY no_of_times_purchased DESC
    LIMIT 1
      ````
      
| Item        | no_of_times_purchased  |
| ----------- | ---------------------- |
| ramen       | 8                      |
