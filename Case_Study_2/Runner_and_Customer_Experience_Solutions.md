# Runner and Customer Experience Solutions
## Question 1; How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
````sql
SELECT 
    WEEK(registration_date) AS sign_up_week,
    COUNT(runner_id) AS no_of_runners
FROM
    runners
GROUP BY sign_up_week
ORDER BY sign_up_week;
  ````
  
| sign_up_week | no_of_runners |
| ------------ | ------------- |
| 0            | 1             |
| 1            | 2             |
| 2            | 1             |

## Question 2; What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
````sql
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
  ````

| runner | average_time_to_pick_order |
| ------ | -------------------------- |
| 1      | 1                          |
| 2      | 2                          |
| 3      | 1                          |

## Question 3; Is there any relationship between the number of pizzas and how long the order takes to prepare?
````sql
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
  ````
  
| orders | no_of_pizzas_per_order | pizza_prep_time |
| ------ | ---------------------- | --------------- |
| 4      | 3                      | 29              |
| 3      | 2                      | 21              |
| 10     | 2                      | 15              |
| 1      | 1                      | 10              |
| 2      | 1                      | 10              |
| 5      | 1                      | 10              |
| 7      | 1                      | 10              |
| 8      | 1                      | 20              |

### One can say that there is a relationship between the number of pizzas and time to prepare the order. From the result of the above analysis, the more the number of pizzas an order has, the more time to prepare the order. However, order 8 is the outlier and needs further investigation.

## Question 4; What was the average distance travelled for each customer?
````sql
SELECT 
    c.customer_id AS customer,
    ROUND(AVG(r.distance),2) AS average_distance
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none'
GROUP BY customer;
  ````
  
| customer | average_distance |
| -------- | ---------------- |
| 101      | 20               |
| 102      | 16.73            |
| 103      | 23.4             |
| 104      | 10               |
| 105      | 25               |

## Question 5; What was the difference between the longest and shortest delivery times for all orders?
````sql
SELECT 
(max(r.distance)- min(r.distance)) as difference_between_maximum_mininum_dist
FROM
    customer_orders_cleaned c
        JOIN
    runner_orders_cleaned r ON c.order_id = r.order_id
WHERE
    r.cancellation = 'none';
  ````
  
| difference_between_maximum_mininum_dist |
| --------------------------------------- |
| 15                                      |

## Question 6; What was the average speed for each runner for each delivery? and do you notice any trend for these values?
````sql
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
  ````

| runner | pizza_order | distance | duration | speed_in_kmh |
| ------ | ----------- | -------- | -------- | ------------ |
| 2      | 4           | 23.4     | 40       | 35.1         |
| 1      | 1           | 20       | 32       | 37.5         |
| 3      | 5           | 10       | 15       | 40           |
| 1      | 3           | 13.4     | 20       | 40.2         |
| 1      | 2           | 20       | 27       | 44.44        |
| 2      | 7           | 25       | 25       | 60           |
| 1      | 10          | 10       | 10       | 60           |
| 2      | 8           | 23.4     | 15       | 93.6         |

### From the result of the above analysis, there isn't any standout trend in speed as the lowest and highest speeds are done by the same runner over the same distance.

## Question 7; What is the successful delivery percentage for each runner?
````sql
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
 ````
  
| runner | percentage_successful_delivery |
| ------ | ------------------------------ |
| 1      | 100                            |
| 2      | 75                             |
| 3      | 50                             |
