# D. Pricing and Ratings

# 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes 
# - how much money has Pizza Runner made so far if there are no delivery fees?

SELECT 
    COUNT(CASE
        WHEN pn.pizza_name = 'Meatlovers' THEN ro.order_id
        ELSE NULL
    END) * 12 AS meatlovers,
    COUNT(CASE
        WHEN pn.pizza_name = 'Vegetarian' THEN ro.order_id
        ELSE NULL
    END) * 10 AS vegetarian
FROM
    runner_orders ro
        LEFT JOIN
    customer_orders co ON co.order_id = ro.order_id
        LEFT JOIN
    pizza_names pn ON pn.pizza_id = co.pizza_id
WHERE
    ro.cancellation = '';

# Pizza Runner made $ 138 so far with successful deliveries.

# 2. What if there was an additional $1 charge for any pizza extras?
# Add cheese is $1 extra

SELECT 
    pn.pizza_name,
    CASE WHEN co.extras = '1' THEN 1
    WHEN co.extras = '1, 4' THEN 3
    ELSE NULL END AS extras_charge
FROM
    runner_orders ro
        LEFT JOIN
    customer_orders co ON co.order_id = ro.order_id
        LEFT JOIN
    pizza_names pn ON pn.pizza_id = co.pizza_id
WHERE
    ro.cancellation = ''
AND co.extras != '';

# In total, Pizza Runner collected $5 from extras after successful deliveries

# 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, 
# how would you design an additional table for this new dataset - generate a schema for this new table and 
# insert your own data for ratings for each successful customer order between 1 to 5.


DROP TABLE IF EXISTS runner_ratings;
CREATE TABLE runner_ratings (
  runner_id INTEGER,
  order_id INTEGER,
  rating   INTEGER
);
INSERT INTO runner_ratings
  (runner_id, order_id, rating)
VALUES
  (1, 1, 5),
  (2, 8, 5),
  (2, 7, 4),
  (2, 4, 3),
  (3, 5, 5);
  
  SELECT * FROM runner_ratings;

# 4. Using your newly generated table - can you join all of the information together to form a table which 
# has the following information for successful deliveries?
	#customer_id
	# order_id
	# runner_id
	# rating
	# order_time
	# pickup_time
	# Time between order and pickup
	# Delivery duration
	# Average speed
	# Total number of pizzas

SELECT 
    co.customer_id,
    ro.runner_id,
    rr.rating,
    co.order_time,
    ro.pickup_time,
    MINUTE(TIMEDIFF(ro.pickup_time, co.order_time)) AS order_pickup_duration,
    ro.duration,
    ROUND(AVG(ro.distance/ro.duration),2) AS average_speed,
    COUNT(pizza_id) AS total_number_of_pizzas
FROM
    customer_orders co
        LEFT JOIN
    runner_orders ro ON ro.order_id = co.order_id
    LEFT JOIN runner_ratings rr ON rr.runner_id = ro.runner_id
WHERE ro.cancellation = ''
GROUP BY 1,2,3,4,5,6,7
ORDER BY ro.runner_id;

# E. Bonus Questions

# If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
# Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings 
# was added to the Pizza Runner menu?

SELECT * FROM pizza_toppings;

INSERT INTO pizza_names (pizza_id, pizza_name)
VALUES (3, 'Supreme');

INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 5),
(3, 6),
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(3, 12)