# 🍕 Pizza Sales Analysis

## 📝 Case Description
You're a data-driven pizza maestro tasked with analyzing your pizzeria's sales performance. Armed with a treasure trove of order data, you're on a mission to discover hidden insights and optimize your business for success. By wielding the power of SQL and Power BI, this analysis promises to unlock valuable insights into your pizzeria's sales landscape. Armed with this knowledge, you can make informed decisions, optimize your offerings, and ensure your pizza reigns supreme in the hearts (and stomachs) of your customers.

##  📁 Data Set
- Orders [Data](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/orders.csv)
- Order Details [Data](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/order_details.csv)
- Pizzas [Data](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/pizzas.csv)
- Pizza Types [Data](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/pizza_types.csv)

## 🔧 Tools
- Microsoft SQL Server 2022 for data analysis - View [SQL Scripts](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/Pizza%20Sales%20Analysis.sql)
- Microsoft Power BI for data visualization - View [Dashboard](https://github.com/farens27/SQL-Stuff/blob/main/Microsoft%20SQL%20Server/Pizza%20Sales%20Analysis/Pizza%20Sales%20Analysis.pbix)

##  🔎 Findings
- Total Revenue for the year was $817,860
- Average Order Value was $38.31
- Total Pizza Sold – 50,000
- Total Orders – 21,000
- Average Pizza per Order – 2
- The busiest days are Thursday (3239 orders), Friday (3538 orders), and Saturday (3158 orders). Most sales are recorded on Friday.
- Most orders are placed between 12 pm to 1 pm, and 5 pm to 7 pm.
- Classic pizza has the highest percentage of sales (26.91%), followed by Supreme (25.46%), Chicken (23.96%), and Veggie (23.68%) pizza.
- Large-size pizza records the highest sales (45.89%) followed by medium (30.49%), then small (21.77%). XL and XXL only account for 1.72% and 0.12% respectively.
- Classic Pizza accounts for the highest sales (14,888 pizzas) followed by Supreme (11,987 pizzas), Veggie (11,649 pizzas), and Chicken (11,050 pizzas).
- The top 5 Best Sellers are the Classic Deluxe (2453 pizzas), Barbecue Chicken (2432 pizzas), Hawaiian (2422), Pepperoni (2418 pizzas), and Thai Chicken (2371 pizzas).
- The bottom 5 Worst Sellers are Brie Carre (490 pizzas), Mediterranean (934 pizzas), Calabrese (937 pizzas), Spinach Supreme (950 pizzas) and Soppressata (961).

## 📊 Dashboard
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/4c177ad2-75d6-4c79-b6db-88b7086b8beb)
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/1b0047be-c5d4-490d-a30d-083e9fedb167)

## 💡 Solution

### 1. Total Revenue
````SQL
SELECT
	ROUND(SUM(p.price*od.quantity),2) AS 'Total Revenue'
FROM
	order_details AS od
JOIN
	pizzas AS p
	ON
	p.pizza_id = od.pizza_id
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/0610680e-ec70-4d79-891d-8cc6ea7638eb)

### 2. Average Order Value
````SQL
SELECT
	ROUND(SUM(p.price*od.quantity) / COUNT(DISTINCT od.order_id),2) AS 'Average Order Value'
FROM
	order_details AS od
JOIN
	pizzas AS p
	ON
	od.pizza_id = p.pizza_id
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/c0b5d347-a1cb-4582-9d9a-fa6ef7b4ffab)

### 3. Total Pizza Sold
````SQL
SELECT
	SUM(quantity) AS 'Total Pizza Sold'
FROM
	order_details
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/ae37160f-e187-4791-85d8-571c4db4a2e9)

### 4. Total Orders
````SQL
SELECT
	COUNT(DISTINCT order_id) AS 'Total Orders'
FROM
	order_details
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/dc2847d7-926f-41bc-8d35-0b1d3d7d2a36)

### 5. Average Pizza per Order
````SQL
SELECT
	SUM(quantity) / COUNT(DISTINCT order_id) AS 'Average Pizza per Order'
FROM
	order_details
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/630478fc-bd63-4885-ab30-caa203786153)

### 6. Daily Trends for Total Orders
````SQL
SELECT
	FORMAT(date, 'dddd') AS DayofWeek,
	COUNT(DISTINCT order_id) 'Total Orders'
FROM
	orders
GROUP BY
	FORMAT(date, 'dddd')
ORDER BY
	'Total Orders' DESC
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/a895dc02-e391-4809-99af-a2e7ae43bb25)

### 7. Hourly Trends for Total Orders
````SQL
SELECT
	DATEPART(hour, time) AS Hour,
	COUNT(DISTINCT order_id) 'Total Orders'
FROM
	orders
GROUP BY
	DATEPART(hour, time)
ORDER BY
	Hour
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/6f673737-959c-4940-9c11-b796ab3ad189)

### 8. Percentage of Sales by Pizza Category
````SQL
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
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/0e166387-ab0b-45e4-84d9-dd02b6fb5c7b)

### 9. Percentage of Sales by Pizza Size
````SQL
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
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/7880474d-a261-45cc-b08e-f969c4099704)

### 10. Total Pizza Sold by Pizza Category
````SQL
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
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/cdccc2eb-f1eb-4165-a9df-ed9358f9120d)

### 11. Top 5 Best Sellers by Total Pizza Sold
````SQL
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
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/32075e47-25c3-40fa-87b6-f415d3a5906c)

### 12. Bottom 5 Worst Sellers by Total Pizza Sold
````SQL
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
````
![Capture](https://github.com/farens27/SQL-Stuff/assets/60220519/0bc1168e-02b4-4856-8c99-ed2a9b262309)
