  #Pizza Metrics
  # Question 1; How many pizzas were ordered?
 SELECT 
    COUNT(customer_orders_cleaned.pizza_id) AS number_of_pizzas_ordered
FROM
    customer_orders_cleaned; 
/* note; There are issues with the data in the customer_order table. 
There is no unique colum. Therefore, there are duplicates. */
  SELECT 
    order_id, COUNT(order_time)
FROM
    customer_orders_cleaned
GROUP BY order_id
HAVING COUNT(order_time) > 1;

#Question 2; How many unique customer orders were made?
SELECT 
    COUNT(DISTINCT order_id)
FROM
    customer_orders_cleaned; 
 #Question 3; How many successful orders were delivered by each runner?
 SELECT 
    runner_id AS runner, COUNT(duration) as no_of_successful_orders
FROM
    runner_orders_cleaned
WHERE
    cancellation = 'none'
GROUP BY runner_id;

#Question 4;How many of each type of pizza was delivered?
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

#Question 5; How many Vegetarian and Meatlovers were ordered by each customer?
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

#Question 6; What was the maximum number of pizzas delivered in a single order?
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
    
#Question 7; For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
# all delivered pizzas
SELECT 
    *
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none';
#delivered pizzas with at least 1 change
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

#Q8. How many pizzas were delivered that had both exclusions and extras?
SELECT 
        count(c.pizza_id) as delivered_pizzas_with_exclusions_and_extras
    FROM
        customer_orders_cleaned c
    LEFT JOIN runner_orders_cleaned r ON c.order_id = r.order_id
    WHERE
        r.cancellation = 'none' AND
    c.exclusions > 0 AND c.extras > 0;
    
#Q9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
    HOUR(order_time) AS hour_of_day, COUNT(*) AS pizza_ordered
FROM
    customer_orders_cleaned
GROUP BY hour_of_day
ORDER BY hour_of_day;

#Q10 What was the volume of orders for each day of the week?
SELECT 
    dayofweek(order_time) AS week_day, COUNT(*) AS pizza_ordered
FROM
    customer_orders_cleaned
GROUP BY week_day
ORDER BY week_day;
