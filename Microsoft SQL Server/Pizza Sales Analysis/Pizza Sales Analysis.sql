-- 1. Total Revenue 
SELECT
	ROUND(SUM(p.price*od.quantity),2) AS 'Total Revenue'
FROM
	order_details AS od
JOIN
	pizzas AS p
	ON
	p.pizza_id = od.pizza_id

-- 2. Average Order Value
SELECT
	ROUND(SUM(p.price*od.quantity) / COUNT(DISTINCT od.order_id),2) AS 'Average Order Value'
FROM
	order_details AS od
JOIN
	pizzas AS p
	ON
	od.pizza_id = p.pizza_id

-- 3. Total Pizza Sold
SELECT
	SUM(quantity) AS 'Total Pizza Sold'
FROM
	order_details

-- 4. Total Orders
SELECT
	COUNT(DISTINCT order_id) AS 'Total Orders'
FROM
	order_details

-- 5. Average Pizza per Order
SELECT
	SUM(quantity) / COUNT(DISTINCT order_id) AS 'Average Pizza per Order'
FROM
	order_details

-- 6. Daily Trends for Total Orders
SELECT
	FORMAT(date, 'dddd') AS DayofWeek,
	COUNT(DISTINCT order_id) 'Total Orders'
FROM
	orders
GROUP BY
	FORMAT(date, 'dddd')
ORDER BY
	'Total Orders' DESC

-- 7. Hourly Trend for Total Orders
SELECT
	DATEPART(hour, time) AS Hour,
	COUNT(DISTINCT order_id) 'Total Orders'
FROM
	orders
GROUP BY
	DATEPART(hour, time)
ORDER BY
	Hour

-- 8. Percentage of Sales by Pizza Category
SELECT
	category,
	SUM(quantity*price) AS revenue,
	ROUND(SUM(quantity*price)*100/(
		SELECT
			SUM(quantity*price)
		FROM
			pizzas AS p2
		JOIN
			order_details AS od2
			ON
			p2.pizza_id = od2.pizza_id
	), 2) AS percentage_sales
FROM
	pizzas AS p
JOIN
	pizza_types AS pt
	ON
	p.pizza_type_id = pt.pizza_type_id
JOIN
	order_details AS od
	ON
	od.pizza_id = p.pizza_id
GROUP BY
	category
ORDER BY
	percentage_sales DESC

-- 9. Percentage of Sales by Pizza Size
SELECT
	size,
	SUM(quantity*price) AS revenue,
	ROUND(SUM(quantity*price)*100/(
		SELECT
			SUM(quantity*price)
		FROM
			pizzas AS p2
		JOIN
			order_details AS od2
			ON
			p2.pizza_id = od2.pizza_id
	),2) AS percentage_sales
FROM
	pizzas AS p
JOIN
	order_details AS od
	ON
	p.pizza_id = od.pizza_id
GROUP BY
	size
ORDER BY
	percentage_sales DESC

-- 10. Total Pizzas Sold by Pizza Category
SELECT
	category,
	SUM(quantity) AS 'Total Pizza Sold'
FROM
	pizza_types AS pt
JOIN
	pizzas AS p
	ON
	pt.pizza_type_id = p.pizza_type_id
JOIN
	order_details AS od
	ON
	od.pizza_id = p.pizza_id
GROUP BY
	category
ORDER BY
	 'Total Pizza Sold' DESC

-- 11. Top 5 Best Sellers by Total Pizzas Sold
SELECT
	TOP 5
	name,
	SUM(quantity) AS 'Total Pizza Sold'
FROM
	pizza_types AS pt
JOIN
	pizzas AS p
	ON
	pt.pizza_type_id = P.pizza_type_id
JOIN
	order_details AS od
	ON
	od.pizza_id = p.pizza_id
GROUP BY
	name
ORDER BY
	'Total Pizza Sold' DESC


-- 12. Bottom 5 Worst Sellers by Total Pizzas Sold
SELECT
	TOP 5
	name,
	SUM(quantity) AS 'Total Pizza Sold'
FROM
	pizza_types AS pt
JOIN
	pizzas AS p
	ON
	pt.pizza_type_id = p.pizza_type_id
JOIN
	order_details AS od
	ON
	od.pizza_id = p.pizza_id
GROUP BY
	name
ORDER BY
	'Total Pizza Sold'