#Welcome to my take on week 1 of the Danny Ma 8 week SQL challenge
#all data were sourced from https://8weeksqlchallenge.com/case-study-1/

# Creation of Schema and Loading of data
CREATE SCHEMA dannys_diner;
use dannys_diner;
#Create Tables and Load in data
CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales
  (customer_id, order_date, product_id)
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  (product_id, product_name, price)
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members
  (customer_id, join_date)
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');

#Q.1 What is the total amount each customer spent at the restaurant?
SELECT 
    s.customer_id, SUM(m.price) AS Amount_Spent
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;
  
  #Q2. How many days has each customer visited the restaurant?
  SELECT 
    customer_id,
    COUNT(DISTINCT order_date) AS No_of_Days_Visited
FROM
    sales
GROUP BY customer_id;

#Q3. What was the first item from the menu purchased by each customer?
SELECT 
    s.customer_id AS Customer,
    MIN(s.order_date) AS First_order_Date,
    m.product_name AS Item_Purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;

#Q4. What is the most purchased item on the menu and 
#how many times was it purchased by all customers?
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
    LIMIT 1;
    
 #Q5. Which item was the most popular for each customer?
  #For Customer A
SELECT 
        m.product_name as product_name, COUNT(s.product_id) AS no_of_times_purchased
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id
    where customer_id= 'A' 
    GROUP BY s.product_id
    order by no_of_times_purchased desc
    limit 1;
    
    #For customer B	
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
ORDER BY no_of_times_purchased DESC;

#For Customer C
SELECT 
        m.product_name as product_name, COUNT(s.product_id) AS no_of_times_purchased
    FROM
        sales s
    JOIN menu m ON s.product_id = m.product_id
    where customer_id= 'C' 
    GROUP BY s.product_id
    order by no_of_times_purchased desc;
    
    #Q6. Which item was purchased first by the customer after they became a member?

    SELECT
    (m.product_name) AS Item_Purchased,s.order_date as order_date, s.customer_id as Customer
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id join members m2 on s.customer_id=m2.customer_id
WHERE
    s.order_date >= m2.join_date
   group by s.customer_id
   ORDER BY s.order_date ASC;
 
#Q7. Which item was purchased just before the customer became a member?
SELECT 
   s.customer_id as Customer, s.order_date as order_date, m.product_name AS Item_Purchased
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id join members m2 on s.customer_id=m2.customer_id
WHERE
   s.order_date < m2.join_date
group by s.customer_id
ORDER BY s.order_date DESC;

#Q8. What is the total items and amount spent for each member before they became a member?
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
    ORDER BY s.customer_id;

#Q9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier,
#how many points would each customer have?
#first input points into menu table
alter table menu add column points integer after price;
select*from menu;
update menu set points= '200' where product_id='1';
update menu set points='150' where product_id='2';
update menu set points= '120' where product_id='3';
#Number of points for each customer
SELECT 
    s.customer_id AS Customer, SUM(m.points) AS Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;
#hmmm
SELECT 
    (SUM(m.points) * 2) AS Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'A'
        AND order_date BETWEEN '2021-01-07' AND '2021-01-14';
        
#Q10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi
# how many points do customer A and B have at the end of January?
#First, i added the new points to the menu table for the first week of membership
alter table menu add column points_for_week1_membership integer after points;
update menu set points_for_week1_membership = '200' where product_id= '1';
update menu set points_for_week1_membership = '300' where product_id= '2';
update menu set points_for_week1_membership = '240' where product_id= '3';
select * from menu;
# points total for Customer A from membership till end of January
#points during first week of membership
SELECT 
    SUM(m.points_for_week1_membership) as Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'A'
        AND s.order_date BETWEEN '2021-01-07' AND '2021-01-14';
#points after first week of membership in January
SELECT 
    SUM(m.points) AS Total_points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'A'
        AND s.order_date BETWEEN '2021-01-15' AND '2021-01-31';
#Total points in January
select 1020 +0;
#points total for Customer B from membership till end of January
#points during first week of membership
SELECT 
    SUM(m.points_for_week1_membership) as Total_Points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'B'
        AND s.order_date BETWEEN '2021-01-09' AND '2021-01-16';
#points after first week of membership in January
SELECT 
    SUM(m.points) AS Total_points
FROM
    sales s
        JOIN
    menu m ON s.product_id = m.product_id
WHERE
    s.customer_id = 'B'
        AND s.order_date BETWEEN '2021-01-17' AND '2021-01-31';
#Total points in January
select 440+0;

#Bonus Questions
#1
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
    ORDER BY s.customer_id,s.order_date,m.product_name;
#2
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
    from diner_membership;
 # se fini
