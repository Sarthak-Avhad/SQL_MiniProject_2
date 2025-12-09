USE pizza_db;
SELECT * FROM order_details;
SELECT * FROM orders;
SELECT * FROM pizza_types;
SELECT * FROM pizzas;

-- Basic: 

-- 1. Retrieve the total number of orders placed. 
SELECT COUNT(*) "Total Orders"  
FROM orders;

-- 2. Calculate the total revenue generated from pizza sales. 
SELECT ROUND(SUM(pizzas.price * order_details.quantity),2) " Total Revenue"
FROM pizzas 
INNER JOIN order_details ON pizzas.pizza_id = order_details.pizza_id;
 
-- 3. Identify the highest-priced pizza. 
SELECT pizza_types.name , pizzas.price
FROM pizza_types
INNER JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- 4. Identify the most common pizza size ordered. 

SELECT pizzas.size , SUM(order_details.quantity) "Total Pizzas"
FROM pizzas 
INNER JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size;


-- 5. List the top 5 most ordered pizza types along with their quantities. 
SELECT pizza_types.name "Pizzas" , SUM(order_details.quantity) "Total Ordered Pizzas"
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY SUM(order_details.quantity) DESC
LIMIT 5;


-- Intermediate: 

-- 1. Join the necessary tables to find the total quantity of each pizza category ordered. 
SELECT pizza_types.category ,  SUM(order_details.quantity) "Total Quantity Ordered"
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;


-- 2. Determine the distribution of orders by hour of the day. 
SELECT HOUR(time) "order_hour" , COUNT(order_id)  "total_orders"
FROM orders
GROUP BY order_hour
ORDER BY order_hour;


-- 3. Join relevant tables to find the category-wise distribution of pizzas. 
SELECT Category , count( name ) "Total Pizza Types"
FROM pizza_types
GROUP BY category;

-- 4. Group the orders by date and calculate the average number of pizzas ordered per day. 
SELECT orders.date , SUM(order_details.quantity) "total_pizzas"
FROM orders 
JOIN order_details  ON orders.order_id = order_details.order_id
GROUP BY orders.date;


-- 5. Determine the top 3 most ordered pizza types based on revenue. 
SELECT pizza_types.name "Pizza Type", ROUND(SUM(pizzas.price * order_details.quantity),3) "Total Revenue"
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.quantity = order_details.quantity
GROUP BY pizza_types.name
ORDER BY SUM(pizzas.price * order_details.quantity) DESC 
LIMIT 3;


-- Advanced: 

-- 1. Calculate the percentage contribution of each pizza type to total revenue. 
SELECT pizza_types.name "Pizza Type",SUM(pizzas.price * order_details.quantity ) "Total revenue of each pizza type", ROUND(SUM(pizzas.price * order_details.quantity / 817860.05 * 100 ), 2 ) "Percentage contribution of each pizza type" 
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name;


-- 2. Analyze the cumulative revenue generated over time. 
SELECT o.date,ROUND(SUM(od.quantity * p.price),2) AS daily_revenue,SUM(SUM(od.quantity * p.price)) OVER (ORDER BY o.date) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.date
ORDER BY o.date;

-- 3. Determine the top 3 most ordered pizza types based on revenue for each pizza category. 
SELECT pizza_types.category , ROUND(SUM(pizzas.price * order_details.quantity),2) "Top 3 most ordered pizza types"
FROM pizza_types 
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY SUM(pizzas.price * order_details.quantity) DESC
LIMIT 3;
