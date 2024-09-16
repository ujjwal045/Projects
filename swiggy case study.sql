create database swiggy;
use swiggy;

-- Q1:Customers who have never ordered
select name from users
where user_id not in
(
select distinct u.user_id from users as u
join orders as o
on u.user_id = o.user_id);

-- Q2: Average price/dish
select f_name , avg(price) as Avg_Price from food as f
join menu as m
on f.f_id = m.f_id
group by f_name;


-- Q3: Find top restaurant in terms of orders in a given month.
select r_name, count(order_id) as No_of_orders from restaurants as R
join orders as O
on R.r_id = O.r_id
where monthname(date) = "June"
group by r_name
order by No_of_orders desc limit 1;

-- Q4:Restaurants with monthly sales > 500.
SELECT r_name,sum(amount) AS monthly_sales FROM orders as O
JOIN restaurants as R
ON O.r_id = R.r_id
WHERE monthname(date) = "June" 
group by R.r_name
HAVING monthly_sales > 500
order by monthly_sales DESC ;

-- Q5:Show all orders with order details of a particular customer between "10-06-2022" and "10-07-2022".
SELECT O.order_id,OD.f_id,f_name, R.r_name FROM users AS U 
JOIN orders AS O 
ON U.user_id = O.user_id
JOIN order_details as OD
ON O.order_id = OD.order_id
JOIN food as F
ON OD.f_id = F.f_id
JOIN restaurants as R
ON R.r_id = O.r_id
WHERE name = "Ankit" AND date BETWEEN "2022-06-10" and "2022-07-10" 
ORDER BY R.r_name ASC;


-- Q6: Find restaurant with max repeated customers.
SELECT T.r_id, R.r_name,count(T.user_id) AS No_of_loyal_customers,
GROUP_CONCAT( DISTINCT name separator ',' ) AS customer_name FROM(
SELECT r_id,user_id,count(user_id) as visits_by_a_customer from orders 
group by user_id,r_id
HAVING count(user_id) >1 ) AS T
JOIN Restaurants AS R
ON R.r_id = T.r_id
JOIN users as U
ON U.user_id = T.user_id
GROUP BY T.r_id,R.r_name
ORDER BY No_of_loyal_customers DESC
LIMIT 1;


-- Q7: Month over month revenuw growth for swiggy.
with sales as 
(select monthname(date) as month, sum(amount) as Revenue from orders
group by month)
select month, Revenue, lag(revenue) over(order by revenue) as prev_month_revenue,
round((( Revenue-lag(revenue) over(order by revenue))/lag(revenue) over(order by revenue) * 100 ),2) as MoM_growth
 from sales;


-- Q8: Find customer and their favourite food.
select T2.name, T3.f_name from
(
select U.user_id,Od.f_id, count(f_id) as max_frequency,
dense_rank()over(partition by user_id order by count(f_id) desc) as rnk from order_details as OD
JOIN orders as O
ON OD.order_id = O.order_id
JOIN users as U
ON U.user_id = O.user_id
group by U.user_id,f_id) as T1
JOIN users as T2
ON T1.user_id = T2.user_id
JOIN food as T3
ON T1.f_id = T3.f_id
where rnk =1;






















