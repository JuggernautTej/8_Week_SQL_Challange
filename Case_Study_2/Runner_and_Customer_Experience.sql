#Q1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
    WEEK(registration_date) AS sign_up_week,
    COUNT(runner_id) AS no_of_runners
FROM
    runners
GROUP BY sign_up_week
ORDER BY sign_up_week;

#Q2. What was the average time in minutes it took for each runner to arrive
# at the Pizza Runner HQ to pickup the order?
SELECT 
    r.runner_id AS runner,
   avg( TIMESTAMPDIFF(MINUTE,
        c.order_time,
        r.pickup_time)) AS average_time_to_pick_order
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none'
GROUP BY r.runner_id;

#Q3. Is there any relationship between the number of pizzas 
#and how long the order takes to prepare?
SELECT 
    r.order_id AS orders, count(c.pizza_id) as no_of_pizzas_per_order,
   TIMESTAMPDIFF(MINUTE,
        c.order_time,
        r.pickup_time) AS pizza_prep_time
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none'
    group by orders
    order by no_of_pizzas_per_order desc;
/*# One can say that there is a relationship between the number of pizzas and time to prepare
the order. From the result of the above analysis, the more the number of pizzas an order has,
the more time to prepare the order. However, order 8 is the outlier and needs further 
investigation. */

#Q4. What was the average distance travelled for each customer?
SELECT 
    c.customer_id AS customer,
    AVG(r.distance) AS average_distance
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none'
GROUP BY customer;

#Q5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
(max(r.distance)- min(r.distance)) as difference_between_maximum_mininum_dist
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none';

#Q6. What was the average speed for each runner for each delivery?
# and do you notice any trend for these values?
SELECT 
   runner_id AS runner,
   order_id AS pizza_order,
   distance, duration,
    ROUND((distance*60 / duration), 2) AS speed_in_kmh
FROM
    runner_orders_cleaned
WHERE
    cancellation = 'none'
ORDER BY speed_in_kmh;
/*  From the result of the above analysis, there isn't any standout trend in speed as
the lowest and highest speeds are done by the same runner over the same distance */

#Q7. What is the successful delivery percentage for each runner?
SELECT
runner_id as runner, 
    round((SUM(CASE
        WHEN cancellation = 'none' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN cancellation = 'none' THEN 1
        ELSE 1
    END)) * 100, 2) AS percentage_successful_delivery
FROM
    runner_orders_cleaned
GROUP BY runner_id;
