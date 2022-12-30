# Pizza Metrics Solutions
## Question 1; How many pizzas were ordered?
````sql
 SELECT 
    COUNT(customer_orders_cleaned.pizza_id) AS number_of_pizzas_ordered
FROM
    customer_orders_cleaned; 
 ````

| number_of_pizzas_ordered | 
| ------------------------ |
| 14                       | 

## Question 2; How many unique customer orders were made?
````sql
SELECT 
    COUNT(DISTINCT order_id) as Unique_Orders
FROM
    customer_orders_cleaned
 ````
 
| Unique_Orders | 
| ------------- |
| 10            | 

## Question 3; How many successful orders were delivered by each runner?
````sql
SELECT 
    runner_id AS runner, COUNT(duration) as no_of_successful_orders
FROM
    runner_orders_cleaned
WHERE
    cancellation = 'none'
GROUP BY runner_id;
 ````
 
| runner | no_of_successful_orders |
| ------ | ----------------------- |
| 1      | 4                       |
| 2      | 3                       |
| 3      | 1                       |

## Question 4;How many of each type of pizza was delivered?
````sql
SELECT 
    a.pizza_id AS pizza_type,
    COUNT(a.pizza_id) AS number_delivered
FROM
    (SELECT 
        r.runner_id, c.pizza_id
    FROM
        customer_orders_cleaned c
    JOIN runner_orders_cleaned r ON c.order_id = r.order_id
    WHERE
        r.cancellation = 'none') AS a
GROUP BY a.pizza_id;
 ````

| pizza_type | number_delivered |
| ---------- | ---------------- |
| 1          | 9                |
| 2          | 3                |
