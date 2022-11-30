# Data Cleaning
# customer_orders table
/* For this table, I converted all blank and 'null' values to 0 in the exclusions and extras columns. Then I saved the cleaned up table as as new table. */
drop  table if exists customer_orders_cleaned;
create table customer_orders_cleaned
select order_id,customer_id,pizza_id,
 case when exclusions = '' or exclusions ='null' then '0' else exclusions end as exclusions,
 case when extras= '' or extras is null or extras ='null' then '0' else extras end as extras,
 order_time from customer_orders;
 SELECT 
    *
FROM
    customer_orders_cleaned;
# runner_orders
/* For this table, I replaced all 'null' values with null in the pickup_time, distance and duration columns. 
I made all entries in the distance and duration columns numbers only except for the null entries.Also, I converted the pickup_time column to datetime data type. 
Finally, I converted the 'null' entries in the cancellation column to 'none'.*/

drop table if exists runner_orders_cleaned;
create table runner_orders_cleaned
select order_id, runner_id,
cast(case when pickup_time = 'null'then null else pickup_time end as datetime) as pickup_time,
case when distance ='null' then null 
when distance like '%km%' then trim( 'km' from distance) else distance end  as distance,
case when duration ='null'then null
when duration like '%minutes%' then trim('minutes' from duration)
when duration like '%minute%' then trim('minute' from duration)
when duration like '%mins%' then trim('mins' from duration)
else duration end as duration,
case when cancellation = '' or cancellation is null or cancellation ='null' then 'none'
else cancellation end as cancellation 
from runner_orders;

#pizza_toppings
 /* I added a record for the 0 value to represent no toppings. */
insert into pizza_toppings (topping_id, topping_name) values (0, 'no topping');
select * from pizza_toppings;
