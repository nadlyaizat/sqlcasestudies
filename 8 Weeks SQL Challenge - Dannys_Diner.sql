/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
    s.customer_id, 
    SUM(m.price) AS total_spent
FROM
    sales s
        LEFT JOIN
    menu m ON m.product_id = s.product_id
GROUP BY 1;

#Customer A spent $76, customer B spent $74 and customer C spent $36


-- 2. How many days has each customer visited the restaurant?

SELECT 
    customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM
    sales
GROUP BY 1;

# Customer A has visited the restaurant for 4 days, while customer B spent 6 days and customer C spent 2 days.


-- 3. What was the first item from the menu purchased by each customer?

SELECT 
    s.customer_id, m.product_name, MIN(s.order_date) AS first_time_order
FROM
    sales s
LEFT JOIN menu m ON m.product_id = s.product_id
GROUP BY 1,2;

# Customer A order sushi for the first time. Customer B ordered curry, and Customer C order ramen.


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
    m.product_name, COUNT(s.product_id) AS items
FROM
    sales s 
LEFT JOIN menu m ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC;

# Ramen is the most purchased items on the menu which was ordered 8 times. 



-- 5. Which item was the most popular for each customer?
SELECT 
    s.customer_id, m.product_name, COUNT(s.product_id) AS items
FROM
    sales s 
LEFT JOIN menu m ON m.product_id = s.product_id
GROUP BY 1,2
ORDER BY 3 DESC;

# Customer A loves ramen, Customer B loves all equally and Customer C loves ramen. 

-- 6. Which item was purchased first by the customer after they became a member?

SELECT 
    mb.customer_id, m.product_name, MIN(s.order_date) AS date_purchase_first
FROM
    members mb
LEFT JOIN sales s ON s.customer_id = mb.customer_id
LEFT JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date > mb.join_date
GROUP BY 1,2;

# Customer A purchased ramen right after joining as member, while Customer B ordered sushi right after becoming member



-- 7. Which item was purchased just before the customer became a member?

SELECT 
    mb.customer_id, m.product_name, MAX(s.order_date) AS date_purchased
FROM
    members mb
LEFT JOIN sales s ON s.customer_id = mb.customer_id
LEFT JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < mb.join_date
GROUP BY 1,2;

# Customer A ordered sushi and curry right before joining as member, while Customer B ordered sushi just right before registration


-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
    mb.customer_id, 
    COUNT(s.product_id) AS total_items, 
    SUM(m.price) AS amount_spent
FROM
    members mb
        LEFT JOIN
    sales s ON s.customer_id = mb.customer_id
        LEFT JOIN
    menu m ON m.product_id = s.product_id
WHERE
    s.order_date < mb.join_date
GROUP BY 1;

#Customer A ordered two items worth $25 while Customer B ordered 3 items worth $40 before member registration


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    mb.customer_id,
    m.product_name,
    SUM(CASE
        WHEN m.product_name = 'sushi' THEN m.price * 20
        ELSE m.price * 10
    END) AS points_earned
FROM
    members mb
        LEFT JOIN
    sales s ON s.customer_id = mb.customer_id
        LEFT JOIN
    menu m ON m.product_id = s.product_id
WHERE
    s.order_date > mb.join_date
GROUP BY 1 , 2;

#Customer A collected 360 points while Customer B collected 440 points


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, 
#  not just sushi - how many points do customer A and B have at the end of January?

SELECT 
    mb.customer_id,
    m.product_name,
    SUM(m.price*20) AS points_earned
FROM
    members mb
        LEFT JOIN
    sales s ON s.customer_id = mb.customer_id
        LEFT JOIN
    menu m ON m.product_id = s.product_id
WHERE
    s.order_date > mb.join_date
AND s.order_date < '2021-01-31'
GROUP BY 1 , 2;

# By end of January, Customer A collected 720 points while Customer B collected 440 points

