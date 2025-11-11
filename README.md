# Netflix Movies and TV Shows Data Analysis using SQL

![](https://github.com/najirh/netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT type ,COUNT(type) AS TOTAL
FROM NETFLIX
GROUP BY type;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql

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
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT type ,title , release_year FROM NETFLIX
WHERE type ='Movie' AND  release_year=2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
	  UNNEST(STRING_TO_ARRAY(country,',')) AS NEW_COUNTRY,
	  COUNT(show_id) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY NEW_COUNTRY
ORDER BY TOTAL_CONTENT DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * FROM NETFLIX
WHERE type = 'Movie' 
	  AND duration = (SELECT MAX(duration) FROM NETFLIX);
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT * 
FROM NETFLIX 
WHERE 
    TO_DATE(date_added , 'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS';
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * FROM NETFLIX
WHERE director ='Rajiv Chilaka';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * FROM NETFLIX 
WHERE 
	type = 'TV Show'
	AND 
	SPLIT_PART(duration, ' ', 1 ):: NUMERIC> 5 
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT 
		UNNEST(STRING_TO_ARRAY(listed_in,',')) AS GENRE,
		COUNT(show_id) AS TOTAL_CONTENT
FROM NETFLIX
GROUP BY GENRE
ORDER BY TOTAL_CONTENT DESC;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
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
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT 
	  type,
	  title,
	  listed_in
FROM NETFLIX
WHERE type='Movie'
	  AND
	  listed_in LIKE '%Documentaries';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT show_id, type, title,director
FROM NETFLIX
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT COUNT(type) AS TOTAL_MOVIES
FROM NETFLIX 
WHERE 
		TO_DATE(date_added , 'MONTH DD,YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'
		AND casts LIKE '%Salman Khan%';
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT 
	  UNNEST(STRING_TO_ARRAY(casts,',')) AS ACTORS,
	  COUNT(*) AS TOTAL_CONTENT
FROM NETFLIX 
WHERE country ='India'
GROUP BY ACTORS
ORDER BY TOTAL_CONTENT DESC 
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
WITH CTE_TABLE AS(
SELECT *,
		CASE
			WHEN 
				description LIKE '%kill%' OR
				description LIKE '%violence%' THEN 'BAD CONTENT'
				ELSE 'GOOD CONTENT'
				END category
FROM NETFLIX
)
SELECT 
	category,
	COUNT(*) AS TOTAL_CONTENT
FROM CTE_TABLE
GROUP BY category;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.



## Author - Zero Analyst

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

### Stay Updated and Join the Community

For more content on SQL, data analysis, and other data-related topics, make sure to follow me on social media and join our community:

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/prjptsumit/)

Thank you for your support, and I look forward to connecting with you!
