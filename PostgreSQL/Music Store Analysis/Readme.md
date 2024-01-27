# 🎵 Music Store Analysis

## 📝 Case Description
This project aims to analyze online music store data using PostgreSQL to provide valuable insights for clients and improve the business. The project utilizes tools such as pgAdmin4 to run SQL queries and extract meaningful information. Through the development of 11 carefully crafted queries, the project investigated various aspects of the music store's operations. 

These queries focus on topics such as top-selling music genres, sales performance by the artist, average purchase amounts per customer, sales trends across different countries, popular tracks and albums. By analyzing these aspects, the project seeks to offer actionable insights to clients, enabling them to make informed decisions and enhance the overall success of the online music store.

## 📁 Data Set
Music Store [Databases](https://github.com/farens27/SQL-Stuff/blob/main/PostgreSQL/Music%20Store%20Analysis/Music_Store_database.sql)

## 🔧 Tools
PostgreSQL 16.0 for data analysis - View [SQL Scripts](https://github.com/farens27/SQL-Stuff/blob/main/PostgreSQL/Music%20Store%20Analysis/Music%20Store%20Analysis.sql)

## 💡 Solution

### 1. Who is the senior-most employee based on the job title?

````SQL
SELECT
	first_name,
	last_name,
	title
FROM
	employee
ORDER BY
	hire_date
LIMIT 1
````

### 2. Which countries have the most invoices?

````SQL
SELECT
	billing_country,
	COUNT(*) AS total
FROM
	invoice
GROUP BY
	billing_country
ORDER BY
	total DESC
LIMIT 1
````

### 3. What are the top 3 values of total invoices?

````SQL
SELECT
	total
FROM
	invoice
ORDER BY
	total DESC
LIMIT 3
````

###  4. Which city has the best customers? We want to throw a promotional Music Festival in the city where we make the most money. Write a query that returns one city with the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

````SQL
SELECT
	billing_city,
	SUM(total) AS invoice_total
FROM
	invoice
GROUP BY
	billing_city
ORDER BY
	invoice_total DESC
LIMIT 1
````

### 5. Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money.

````SQL
SELECT
	first_name,
	last_name,
	SUM(total) AS total_spending
FROM
	customer
JOIN
	invoice
	ON
	customer.customer_id = invoice.customer_id
GROUP BY
	first_name,
	last_name
ORDER BY
	total_spending DESC
LIMIT 1
````

### 6. Write a query to return the email, first name, last name, and Genre of all rock music listeners. Return your list ordered alphabetically by email starting with a.

````SQL
SELECT
	DISTINCT c.email,
	c.first_name,
	c.last_name,
	g.name
FROM
	customer AS c
JOIN
	invoice AS i
	ON c.customer_id = i.customer_id
JOIN
	invoice_line AS il
	ON
	i.invoice_id = il.invoice_id
JOIN
	track AS t
	ON
	il.track_id = t.track_id
JOIN
	genre AS g
	ON
	t.genre_id = g.genre_id
WHERE
	g.genre_id = '1'
ORDER BY
	email
````

### 7. Let's invite the artist who has written the most rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 rock bands.

````SQL
SELECT
	a.name,
	COUNT(t.track_id) AS number_of_songs
FROM
	artist AS a
JOIN
	album AS al
	ON
	a.artist_id = al.artist_id
JOIN
	track AS t
	ON
	al.album_id = t.album_id
WHERE
	genre_id = '1'
GROUP BY
	a.name
ORDER BY
	number_of_songs DESC
LIMIT 10
````

### 8. Return all the track names that have a song length longer than the average song length. Return the name and milliseconds for each track. Order by the song length with the longest song listed first.

````SQL
SELECT
	name,
	milliseconds
FROM
	track
WHERE
	milliseconds > (
		SELECT
			AVG(milliseconds)
		FROM
			track
	)
ORDER BY
	milliseconds DESC
````

### 9. Find how much is spent by each customer on the artist. Write a query to return the customer name, artist name, and total spent.

````SQL
WITH
	best_selling_artist AS (
		SELECT
			a.artist_id,
			a.name AS artist_name,
			SUM(il.unit_price * il.quantity) AS total_sales
		FROM
			invoice_line AS il
		JOIN
			track AS t
			ON
			il.track_id = t.track_id
		JOIN
			album AS al
			ON
			t.album_id = al.album_id
		JOIN
			artist AS a
			ON
			al.artist_id = a.artist_id
		GROUP BY
			1
		ORDER BY
			3 DESC
		LIMIT 1
	)
SELECT
	c.first_name,
	c.last_name,
	bsa.artist_name,
	SUM(il.unit_price * il.quantity) AS amount_spent
FROM
	customer AS c
JOIN
	invoice AS i
	ON
	c.customer_id = i.customer_id
JOIN
	invoice_line AS il
	ON
	i.invoice_id = il.invoice_id
JOIN
	track AS t
	ON
	il.track_id = t.track_id
JOIN
	album AS al
	ON
	t.album_id = al.album_id
JOIN
	best_selling_artist AS bsa
	ON
	al.artist_id = bsa.artist_id
GROUP BY
	1,
	2,
	3
ORDER BY
	4 DESC
````

Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find  which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer,  Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, so you need to use the InvoiceLine table to find out how many of each product were purchased, and then multiply this by the price
for each artist.

### 10. We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top genre. For countries where the maximum number of purchases is shared return all genres.

````SQL
WITH
	popular_genre AS (
		SELECT
			c.country,
			g.name,
			COUNT(il.quantity) AS purchase,
			ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(il.quantity)DESC) AS row_num
		FROM
			customer AS c
		JOIN
			invoice AS i
			ON
			c.customer_id = i.customer_id
		JOIN
			invoice_line AS il
			ON
			i.invoice_id = il.invoice_id
		JOIN
			track AS t
			ON
			il.track_id = t.track_id
		JOIN
			genre AS g
			ON
			t.genre_id = g.genre_id
		GROUP BY
			1, 2
		ORDER BY
			1, 3 DESC	
	)
SELECT *
FROM
	popular_genre
WHERE
	row_num <= 1
````

Steps to Solve:  There are two parts in question- first most popular music genre and second need for data at the country level.

### 11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.

````SQL
WITH 
	customer_and_country AS (
		SELECT
			first_name,
			last_name,
			billing_country,
			SUM(total) AS total_spending,
			ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS row_num
		FROM
			customer
		JOIN
			invoice
			ON
			customer.customer_id = invoice.customer_id
		GROUP BY
			1, 
			2, 
			3
		ORDER BY
			3, 
			4 DESC
	)

SELECT *
FROM
	customer_and_country
WHERE
	row_num <= 1
````

Steps to Solve:  Similar to the question before. There are two parts in question-first find the most spent on music for each country and second filter the data for respective customers.
