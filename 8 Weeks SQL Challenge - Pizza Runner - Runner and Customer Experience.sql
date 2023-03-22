#B. Runner and Customer Experience

# 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT 
    YEARWEEK(registration_date) AS wk,
    COUNT(runner_id) AS runners
FROM
    runners
WHERE registration_date > '2021-01-01'
GROUP BY 1;


# 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

SELECT 
    ro.runner_id,
    AVG(MINUTE(TIMEDIFF(co.order_time, ro.pickup_time))) AS average_time
FROM
    runner_orders ro
LEFT JOIN customer_orders co ON co.order_id = ro.order_id
WHERE
    ro.cancellation = ''
GROUP BY 1;

# 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT 
co.order_id,
COUNT(co.pizza_id) AS number_of_pizzas,
MINUTE(TIMEDIFF(co.order_time, ro.pickup_time)) AS preparation_time
FROM runner_orders ro
LEFT JOIN customer_orders co ON co.order_id = ro.order_id
WHERE
    ro.cancellation = ''
GROUP BY 1,3
ORDER BY 2 DESC;

# More time needed to prepare larger orders of pizzas

# 4. What was the average distance travelled for each customer?

SELECT 
    co.customer_id,
    ROUND(AVG(ro.distance),2) AS average_distance
FROM
    runner_orders ro
LEFT JOIN customer_orders co ON ro.order_id = co.order_id
WHERE
    ro.cancellation = ''
GROUP BY 1;

# 5. What was the difference between the longest and shortest delivery times for all orders?

SELECT 
    order_id,
    duration
FROM
    runner_orders
WHERE cancellation = '';

# The difference between longest and shortest delivery times is at 30 minutes

# 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
    ro.runner_id,
    COUNT(co.pizza_id) AS number_of_pizzas,
   ROUND(AVG(ro.distance / ro.duration),2) AS average_speed
FROM
    runner_orders ro
LEFT JOIN customer_orders co ON co.order_id = ro.order_id
WHERE
    ro.cancellation = ''
GROUP BY 1
ORDER BY 3 DESC;

# Runner tends to ride slowly when the amount of pizzas delivered is large

# 7. What is the successful delivery percentage for each runner?

SELECT 
    runner_id,
    SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END) AS success,
    SUM(CASE WHEN cancellation != '' THEN 1 ELSE 0 END) AS failure,
    SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END)
    /(SUM(CASE WHEN cancellation != '' THEN 1 ELSE 0 END) 
    + SUM(CASE WHEN cancellation = '' THEN 1 ELSE 0 END)) 
    AS percentage_success
    FROM
    runner_orders
GROUP BY 1;

# Runner 1 has 100% success, followed by runner 2 with 75% and runner 3 with 50%