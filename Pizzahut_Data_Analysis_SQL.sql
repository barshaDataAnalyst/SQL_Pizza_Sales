create database pizzahut;
use pizzahut;
drop table orders;


create table orders(
order_id int not null,
order_date datetime not null,
order_time time not null,
primary key(order_id)); 


-- Q1. Retrieve the total number of orders placed.
select count(order_id) as Total_Orders from orders;
-- Ans: Total_Orders - 21350

-- Q2. Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(od.quantity * ps.price), 2) AS Total_revenue
FROM
    order_details od
        JOIN
    pizzas ps ON ps.pizza_id = od.pizza_id ;
-- Ans: Total_revenue - 817860.05


-- Q3. Identify the highest-priced pizza.
 select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;
-- Ans: The Greek Pizza - 35.95


-- Q4. Identify the most common pizza size ordered.
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc limit 1; 
-- Ans: L size - 18526


-- Q5. List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;


-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT 
    pizza_types.category, 
    SUM(order_details.quantity) AS total_quantity
FROM 
    pizza_types
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN 
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY 
    pizza_types.category
ORDER BY 
    total_quantity DESC;


-- Q7. Determine the distribution of orders by hour of the day.

select hour(order_time), count(order_id) from orders
group by hour(order_time);

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;

-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(Quantity),0) as avg_pizza_orderd_per_day from 
(select orders.order_date, sum(order_details.quantity) as Quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- Q10. Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by revenue desc limit 3;


-- Q11. Calculate the percentage contribution of each pizza type to total revenue.
  
  select pizza_types.category,
 round(sum(order_details.quantity*pizzas.price) / (select
  round(sum(order_details.quantity*pizzas.price),2) as total_revenue
  from order_details join pizzas
  on order_details.pizza_id = pizzas.pizza_id)* 100,2) as percentage_contribution
  from pizza_types join pizzas
  on pizza_types.pizza_type_id = pizzas.pizza_type_id
  join order_details
  on order_details.pizza_id = pizzas.pizza_id
  group by pizza_types.category order by percentage_contribution desc;




 