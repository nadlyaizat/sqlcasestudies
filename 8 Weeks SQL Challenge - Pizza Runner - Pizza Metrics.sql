# PIZZA METRICS
# 1. How many pizzas were ordered?

SELECT 
    COUNT(order_id) AS orders
FROM
    customer_orders;

# There are 14 orders recorded.

# 2. How many unique customer orders were made?

SELECT 
    COUNT(DISTINCT order_id) AS unique_orders
FROM
    customer_orders;

# There are 10 unique orders

# 3. How many successful orders were delivered by each runner?

SELECT 
    COUNT(CASE
        WHEN cancellation = '' THEN runner_id
        ELSE NULL
    END) AS successful_orders
FROM
    runner_orders;
    
# There are 8 successful orders delivered.


# 4. How many of each type of pizza was delivered?

SELECT 
	co.pizza_id,
    COUNT(CASE
        WHEN ro.cancellation = '' THEN ro.runner_id
        ELSE NULL
    END) AS successful_orders
FROM
    runner_orders ro
LEFT JOIN customer_orders co ON co.order_id = ro.order_id
WHERE ro.cancellation = ''
GROUP BY 1;

#There are 9 of pizza number 1 and 3 for pizza number 2

# 5. How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    pn.pizza_name,
    COUNT(co.order_id) AS orders
FROM
    customer_orders co
LEFT JOIN pizza_names pn ON pn.pizza_id = co.pizza_id
GROUP BY 1;

# There are 10 orders for Meatlovers while 4 orders for Vegetarian

# 6. What was the maximum number of pizzas delivered in a single order?

SELECT 
	ro.order_id,
    COUNT(co.pizza_id) AS number_of_pizzas
FROM
    runner_orders ro
LEFT JOIN customer_orders co ON co.order_id = ro.order_id
WHERE cancellation = ''
GROUP BY 1
ORDER BY 2 DESC;

# There are 3 pizzas delivered in order id 4


# 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
    co.customer_id,
    COUNT(CASE WHEN co.exclusions LIKE '%' OR extras LIKE '%' THEN 1 ELSE 0 END) AS order_change,
    COUNT(CASE WHEN co.exclusions = '' AND extras = '' THEN 1 ELSE 0 END) AS order_unchanged
FROM
    customer_orders co
LEFT JOIN runner_orders ro ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY 1;

# Run the above query for answers.

# 8.How many pizzas were delivered that had both exclusions and extras?
SELECT 
    co.pizza_id,
    COUNT(CASE
        WHEN co.exclusions != '' AND co.extras != '' THEN pizza_id
        ELSE NULL
    END) AS both_exclusions_extras
FROM
    customer_orders co
RIGHT JOIN runner_orders ro ON ro.order_id = co.order_id
WHERE ro.cancellation = ''
GROUP BY 1;

#pizza_id number 1 has one with both. 



# What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	HOUR(order_time) AS hours,
	COUNT(order_id) AS orders
FROM customer_orders
GROUP BY 1
ORDER BY 1;


# What was the volume of orders for each day of the week?

CREATE TEMPORARY TABLE days_of_the_week
SELECT
	WEEKDAY(order_time) AS days,
	COUNT(order_id) AS order_count
FROM customer_orders
GROUP BY days
ORDER BY days;

SELECT 
    order_count,
    CASE
		WHEN days = 1 THEN 'Monday'
        WHEN days = 2 THEN 'Tuesday'
        WHEN days = 3 THEN 'Wednesday'
		WHEN days = 4 THEN 'Thursday'
        WHEN days = 5 THEN 'Friday'
        WHEN days = 6 THEN 'Saturday'
        WHEN days = 7 THEN 'Sunday'
    END AS ordered_day
FROM
    days_of_the_week;
