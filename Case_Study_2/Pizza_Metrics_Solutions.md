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
    customer_orders_cleaned;
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

## Question 5; How many Vegetarian and Meatlovers were ordered by each customer?
````sql
SELECT 
    customer_id,
    SUM(CASE
        WHEN pizza_id = 1 THEN 1
        ELSE 0
    END) AS meatlovers,
    SUM(CASE
        WHEN pizza_id = 2 THEN 1
        ELSE 0
    END) AS vegetarians
FROM
    customer_orders_cleaned
GROUP BY customer_id;
````

| customer_id | meatlovers | vegetarians |
| ----------- | ---------- | ----------- |
| 101         | 2          | 1           |
| 102         | 2          | 1           |
| 103         | 3          | 1           |
| 104         | 3          | 0           |
| 105         | 0          | 1           |



## Question 6; What was the maximum number of pizzas delivered in a single order?
````sql
SELECT 
    c.order_id as order_id, count(c.pizza_id) as no_of_pizza_delivered_per_order
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id 
    WHERE r.cancellation= 'none'
    GROUP BY order_id
    ORDER BY no_of_pizza_delivered_per_order DESC
    LIMIT 1;
````

| order_id | no_of_pizza_delivered_per_order |
| -------- | ------------------------------- |
| 4        | 9                               |

## Question 7; For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
````sql
SELECT 
    c.customer_id AS customer,
    SUM(CASE
        WHEN c.exclusions <> '0'  or c.extras <> '0' THEN 1
        ELSE 0
    END) AS delivered_pizzas_with_changes,
    SUM(CASE
        WHEN c.exclusions = '0' and c.extras = '0' THEN 1
        ELSE 0
    END) AS delivered_pizzas_with_no_change
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none'
GROUP BY c.customer_id;
````

| customer_id | delivered_pizzas_with_changes | delivered_pizzas_with_no_change |
| ----------- | ----------------------------- | ------------------------------- |
| 101         | 0                             | 2                               |
| 102         | 0                             | 3                               |
| 103         | 3                             | 0                               |
| 104         | 2                             | 1                               |
| 105         | 1                             | 0                               |

## Question 8; How many pizzas were delivered that had both exclusions and extras?
````sql
SELECT 
        count(c.pizza_id) as delivered_pizzas_with_exclusions_and_extras
    FROM
        customer_orders_cleaned c
    LEFT JOIN runner_orders_cleaned r ON c.order_id = r.order_id
    WHERE
        r.cancellation = 'none' AND
    c.exclusions > 0 AND c.extras > 0;
````
| delivered_pizzas_with_exclusions_and_extras | 
| ------------------------------------------- |
| 1                                           | 

## Question 9; What was the total volume of pizzas ordered for each hour of the day?
````sql
SELECT 
    HOUR(order_time) AS hour_of_day, COUNT(*) AS pizza_ordered
FROM
    customer_orders_cleaned
GROUP BY hour_of_day
ORDER BY hour_of_day;
````

| hour_of_day | pizza_ordered |
| ----------- | ------------- |
| 11          | 1             |
| 13          | 3             |
| 18          | 3             |
| 19          | 1             |
| 21          | 3             |
| 23          | 3             |

## Question 10; What was the volume of orders for each day of the week?
````sql
SELECT 
    dayofweek(order_time) AS week_day, COUNT(*) AS pizza_ordered
FROM
    customer_orders_cleaned
GROUP BY week_day
ORDER BY week_day;
````
| week_day | pizza_ordered |
| -------- | ------------- |
| 4        | 5             |
| 5        | 3             |
| 6        | 1             |
| 7        | 5             |


