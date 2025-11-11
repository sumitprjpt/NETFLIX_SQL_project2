CREATE TABLE NETFLIX
				(
					show_id	VARCHAR(6),
					type	VARCHAR(15),
					title	VARCHAR(105),
					director VARCHAR(225),
					casts	VARCHAR(800),
					country	VARCHAR(150),
					date_added	VARCHAR(20),
					release_year INT,
					rating	VARCHAR(10),
					duration  VARCHAR(15),
					listed_in	VARCHAR(100),
					description VARCHAR(300)
)

SELECT * FROM NETFLIX;


-- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

SELECT type ,COUNT(type) AS TOTAL
FROM NETFLIX
GROUP BY type;

--2. Find the most common rating for movies and TV shows

SELECT type,
		rating
FROM
	(SELECT 
			type , 
			rating, 
			COUNT(*),
			RANK()OVER(PARTITION BY type ORDER BY COUNT(*)DESC)
	FROM NETFLIX
	GROUP BY type,rating) AS T1
WHERE RANK=1;


--3. List all movies released in a specific year (e.g., 2020)

SELECT type ,title , release_year FROM NETFLIX
WHERE type ='Movie' AND  release_year=2020;

--4. Find the top 5 countries with the most content on Netflix

SELECT 
	  UNNEST(STRING_TO_ARRAY(country,',')) AS NEW_COUNTRY,
	  COUNT(show_id) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY NEW_COUNTRY
ORDER BY TOTAL_CONTENT DESC
LIMIT 5;

--5. Identify the longest movie

SELECT * FROM NETFLIX
WHERE type = 'Movie' 
	  AND duration = (SELECT MAX(duration) FROM NETFLIX);
	  

--6. Find content added in the last 5 years

SELECT * 
FROM NETFLIX 
WHERE 
		TO_DATE(date_added , 'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM NETFLIX
WHERE director ='Rajiv Chilaka';

--8. List all TV shows with more than 5 seasons

SELECT * FROM NETFLIX 
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART(duration, ' ', 1 ):: NUMERIC> 5 

	
--9. Count the number of content items in each genre

SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in,',')) AS GENRE,
		COUNT(show_id) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY GENRE
ORDER BY TOTAL_CONTENT DESC;


--10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

WITH country_counts AS (
    SELECT 
        release_year,
        TRIM(UNNEST(string_to_array(country, ','))) AS new_country
    FROM netflix
    WHERE country IS NOT NULL
)
SELECT 
    release_year,
    COUNT(DISTINCT new_country) AS country_count
FROM country_counts
GROUP BY release_year
ORDER BY release_year DESC
LIMIT 5;
		

--11. List all movies that are documentaries

SELECT 
	  type,
	  title,
	  listed_in
FROM NETFLIX
WHERE type='Movie'
	  AND
	  listed_in LIKE '%Documentaries';
			

--12. Find all content without a director

SELECT show_id, type, title,director
FROM NETFLIX
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(type) AS TOTAL_MOVIES
FROM NETFLIX 
WHERE 
		TO_DATE(date_added , 'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'
		AND casts LIKE '%Salman Khan%';

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	  UNNEST(STRING_TO_ARRAY(casts,',')) AS ACTORS,
	  COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX 
WHERE country ='India'
GROUP BY ACTORS
ORDER BY TOTAL_CONTENT DESC 
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'. 
--Count how many items fall into each category.

SELECT *,
		CASE
			WHEN 
				description LIKE '%kill%' OR
				description LIKE '%violence%' THEN 'BAD CONTENT'
				ELSE 'GOOD CONTENT'
				END category
FROM NETFLIX;
			
