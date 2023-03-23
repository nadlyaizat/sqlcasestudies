# C. Ingredient Optimisation
# 1. What are the standard ingredients for each pizza?
SELECT 
    pizza_id,
    CASE WHEN toppings = '1' THEN 'Bacon'
    WHEN toppings = '2' THEN 'BBQ Sauce' 
    WHEN toppings = '3' THEN 'Beef'
    WHEN toppings = '4' THEN 'Cheese'
    WHEN toppings = '5' THEN 'Chicken'
    WHEN toppings = '6' THEN 'Mushrooms'
    WHEN toppings = '7' THEN 'Onions'
    WHEN toppings = '8' THEN 'Pepperoni'
    WHEN toppings = '9' THEN 'Peppers'
    WHEN toppings = '10' THEN 'Salami'
    WHEN toppings = '11' THEN 'Tomatoes'
    WHEN toppings = '12' THEN 'Tomato Sauce'
    END AS topping_name
FROM
    pizza_recipes;
    
# 2. What was the most commonly added extra?

SELECT 
    pizza_id,
    extras
FROM
    customer_orders
WHERE extras != '';

# Bacon is the most commonly added extras

# 3. What was the most common exclusion?

SELECT 
    pizza_id,
    exclusions
FROM
    customer_orders
WHERE exclusions != '';

# Cheese is the most common exclusions
    
# Generate an order item for each record in the customers_orders table in the format of one of the following:
# Meat Lovers
# Meat Lovers - Exclude Beef
# Meat Lovers - Extra Bacon
# Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers


# Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
# For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
# What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?