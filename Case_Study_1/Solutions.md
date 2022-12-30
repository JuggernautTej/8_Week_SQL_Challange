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

## Q5. Which item was the most popular for each customer?
  ### For Customer A
````sql
SELECT 
        m.product_name as product_name, COUNT(s.product_id) AS no_of_times_purchased
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id
    where customer_id= 'A' 
    GROUP BY s.product_id
    order by no_of_times_purchased desc
    limit 1
 ````
   
| product_name | no_of_times_purchased  |
| ------------ | ---------------------- |
| ramen        | 3                      |

  ### For Customer B	
````sql
   SELECT 
    m.product_name AS product_name,
    COUNT(s.product_id) AS no_of_times_purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    customer_id = 'B'
GROUP BY s.product_id
ORDER BY no_of_times_purchased DESC
  ````

| product_name | no_of_times_purchased  |
| ------------ | ---------------------- |
| sushi        | 2                      |
| curry        | 2                      |
| ramen        | 2                      |

   ### For Customer C
````sql
SELECT 
        m.product_name as product_name, COUNT(s.product_id) AS no_of_times_purchased
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id
    where customer_id= 'C' 
    GROUP BY s.product_id
    order by no_of_times_purchased desc
  ````
      
| product_name | no_of_times_purchased  |
| ------------ | ---------------------- |
| ramen        | 3                      |

 ## Q6. Which item was purchased first by the customer after they became a member?
````sql
    SELECT
    (m.product_name) AS Item_Purchased,s.order_date as order_date, s.customer_id as Customer
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id join members m2 on s.customer_id=m2.customer_id
WHERE
    s.order_date >= m2.join_date
   group by s.customer_id
   ORDER BY s.order_date ASC
  ````
  
| Item_Purchased | order_date | Customer   |
| -------------- | ---------- | ---------- |
| curry          | 2021-01-07 | A          |
| sushi          | 2021-01-11 | B          |

 
## Q7. Which item was purchased just before the customer became a member?
````sql
SELECT 
   s.customer_id as Customer, s.order_date as order_date, m.product_name AS Item_Purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id join members m2 on s.customer_id=m2.customer_id
WHERE
   s.order_date < m2.join_date
group by s.customer_id
ORDER BY s.order_date DESC
  ````

| Customer | order_date | Item_Purchased  |
| -------- | ---------- | --------------- |
| B        | 2021-01-04 | sushi           |
| A        | 2021-01-01 | sushi           |

## Q8. What is the total items and amount spent for each member before they became a member?
````sql
SELECT 
    s.customer_id as Customer,
    COUNT(s.product_id) AS Total_Items_Bought,
    SUM(m.price) AS Total_Amount_Spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id join members m2 on s.customer_id=m2.customer_id
WHERE
    s.order_date < m2.join_date
    GROUP BY s.customer_id
    ORDER BY s.customer_id
  ````
  
| Customer | Total_Items_Bought | Total_Amount_Spent  |
| -------- | ------------------ | ------------------- |
| A        | 2                  | 25                  |
| B        | 3                  | 40                  |

## Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier,how many points would each customer have?
### First, input points into menu table
````sql
alter table menu add column points integer after price;
update menu set points= '200' where product_id='1';
update menu set points='150' where product_id='2';
update menu set points= '120' where product_id='3';
select*from menu;
  ````
 
| product_id | product_name | price  | points |
| ---------- | ------------ | ------ | ------ |
| 1          | sushi        | 10     | 200    | 
| 2          | curry        | 15     | 150    | 
| 3          | ramen        | 12     | 120    |
                   
### Number of points for each customer
````sql
SELECT 
    s.customer_id AS Customer, SUM(m.points) AS Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
  ````

| Customer | Total_Points |
| -------- | ------------ |
| A        | 860          |
| B        | 940          | 
| C        | 360          |
        
## Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi. how many points do customer A and B have at the end of January?
### First, i added the new points to the menu table for the first week of membership
````sql
alter table menu add column points_for_week1_membership integer after points;
update menu set points_for_week1_membership = '200' where product_id= '1';
update menu set points_for_week1_membership = '300' where product_id= '2';
update menu set points_for_week1_membership = '240' where product_id= '3';
select * from menu;
  ````
  
| product_id | product_name | price | points | points_for_week1_membership |
| ---------- | ------------ | ----- | ------ | --------------------------- |
| 1          | sushi        | 10    | 200    | 200                         |
| 2          | curry        | 15    | 150    | 300                         |
| 3          | ramen        | 12    | 120    | 240                         |

### points total for Customer A from membership till end of January
````sql
SELECT 
    SUM(m.points_for_week1_membership) as Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'A'
        AND s.order_date BETWEEN '2021-01-07' AND '2021-01-14'
 ````
 
| Total_Points |
| ------------ |
| 1020         |


### points total for Customer B from membership till end of January
### points during first week of membership
````sql
SELECT 
    SUM(m.points_for_week1_membership) as Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'B'
        AND s.order_date BETWEEN '2021-01-09' AND '2021-01-16';
  ````
  
| Total_Points |
| ------------ |
| 440          |
  
### Customer C is not a paying member.

## Bonus Questions
### A. Recreate Recreate the following table output using the available data:

![SQLChallengeWeek1_Bonus Question A](https://user-images.githubusercontent.com/88348888/204283728-a793d544-315b-48f0-a2e3-6e6f8f3e245b.JPG)

````sql
SELECT 
    s.customer_id AS customer,
    s.order_date AS order_date,
    m.product_name AS product_name,
    m.price AS price,
    CASE
        WHEN m2.join_date > s.order_date THEN 'N'
        WHEN m2.join_date <= s.order_date THEN 'Y' else 'N'
    END AS diner_member
FROM
    sales s
        LEFT JOIN
    menu m ON s.product_id = m.product_id
        LEFT JOIN
    members m2 ON s.customer_id = m2.customer_id
    ORDER BY s.customer_id,s.order_date,m.product_name
  ````
  
| customer |  order_date | product_name | price | diner_member|
| -------- | ----------- | ------------ | ----- | ----------- |
| A        | 2021-01-01  | curry        | 15    | N           |
| A        | 2021-01-01  | sushi        | 10    | N           |
| A        | 2021-01-07  | curry        | 15    | Y           |
| A        | 2021-01-10  | ramen        | 12    | Y           |
| A        | 2021-01-11  | ramen        | 12    | Y           |
| A        | 2021-01-11  | ramen        | 12    | Y           |
| B        | 2021-01-01  | curry        | 15    | N           |
| B        | 2021-01-02  | curry        | 15    | N           |
| B        | 2021-01-04  | sushi        | 10    | N           |
| B        | 2021-01-11  | sushi        | 10    | Y           |
| B        | 2021-01-16  | ramen        | 12    | Y           |
| B        | 2021-02-01  | ramen        | 12    | Y           |
| C        | 2021-01-01  | ramen        | 12    | N           |
| C        | 2021-01-01  | ramen        | 12    | N           |
| C        | 2021-01-07  | ramen        | 12    | N           |

### B.Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.
````sql
with diner_membership as (SELECT 
    s.customer_id AS customer,
    s.order_date AS order_date,
    m.product_name AS product_name,
    m.price AS price,
    CASE
        WHEN m2.join_date > s.order_date THEN 'N'
        WHEN m2.join_date <= s.order_date THEN 'Y' else 'N'
    END AS diner_member
FROM
    sales s
        LEFT JOIN
    menu m ON s.product_id = m.product_id
        LEFT JOIN
    members m2 ON s.customer_id = m2.customer_id
    ORDER BY s.customer_id,s.order_date,m.product_name)
    select * , 
    case 
    when diner_member = 'N' then 'null' 
    else rank() over(partition by customer, diner_member order by order_date)
    end as ranking 
    from diner_membership
      ````
| customer |  order_date | product_name | price | diner_member | ranking |
| -------- | ----------- | ------------ | ----- | -----------  |-------  |
| A        | 2021-01-01  | curry        | 15    | N            | null    |
| A        | 2021-01-01  | sushi        | 10    | N            | null    |
| A        | 2021-01-07  | curry        | 15    | Y            | 1       |
| A        | 2021-01-10  | ramen        | 12    | Y            | 2       |
| A        | 2021-01-11  | ramen        | 12    | Y            | 3       |
| A        | 2021-01-11  | ramen        | 12    | Y            | 3       |
| B        | 2021-01-01  | curry        | 15    | N            | null    |
| B        | 2021-01-02  | curry        | 15    | N            | null    |
| B        | 2021-01-04  | sushi        | 10    | N            | null    |
| B        | 2021-01-11  | sushi        | 10    | Y            | 1       |
| B        | 2021-01-16  | ramen        | 12    | Y            | 2       |
| B        | 2021-02-01  | ramen        | 12    | Y            | 3       |
| C        | 2021-01-01  | ramen        | 12    | N            | null    |
| C        | 2021-01-01  | ramen        | 12    | N            | null    |
| C        | 2021-01-07  | ramen        | 12    | N            | null    |
    
