select * from netflix;

--1. count the number of movies vs tv shows
select type,
count(*) as totla_content
from netflix
group by type;

--2. find the most common rating fo rmovies and tv shows

select 
	type,
	rating
from

(
select 
	type,
	rating,
	--max rating
	count(*),
	rank() over(partition by type order by count(*)desc) as ranking
from netflix
group by 1, 2
) as t1
where ranking =1;

--3. list all movies released in a specific year (eg.2020)

select * from netflix 
	where 
	type='Movie' 
	and 
	release_year=2020;

--4. find the top 5 countries with the most content on netflix

select
	unnest (String_to_array(country,',')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;

--5. identify the longest movie

select * from netflix
where
	type='Movie'
	and 
    duration = (select max(duration) from netflix);

--6. find content added in the last 5 years

select *
from netflix
where
   To_Date(date_added, 'month dd, yyyy') >= current_date - interval '5 years';

--select current_date - interval '5 years'

--7. find all the movies/tv shows
--by director 'Rajiv Chilaka'

select * from netflix
where director ilike '%Rajiv Chilaka%';

--8. list all tv shows with more than 5 seasons

select 
	*
from netflix
where 
	type = 'TV Show'
	and
	split_part(duration, ' ', 1)::numeric > 5;

--9. count the number of content items in each genre

select 
    unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1;

--10. find each year and the average numbers of content
-- release by india on netlflix, return top 5 year with highest avg content release

select 
	extract(year from to_date(date_Added, 'Month DD YYYY')) as date,
	count(*) as yeraly_content,
	round(
	count(*)::numeric/(select count(*) from netflix where country = 'India') * 100 
	,2)as avg_content
from netflix
where country ='India'
group by 1;

--11. list all the movies that are documentaries

select * from netflix
where 
	listed_in ilike '%documentaries%';

--12. find all content without a director

select * from netflix
where
director is null;

--13. find how many movies actor 'Salman Khan' appeared in last 10 years

select * from netflix
where
	casts like '%Salman Khan%'
    and
    release_year > extract(year from current_date) -10;

--14. find the top 10 actors who have appeared in the
--highest number of movies produced in India

select 
	unnest(string_to_array(casts, ',')) as actors,
	count(*) as total_content
from netflix
	where country ilike '%India'
group by 1
order by 2 desc
limit 10;

--15. categorize the content based on the presence of the keywords 'Kill' and 'Violence' in
--the description field. label content containing these keywords as 'Bad' and
--all other content 'Good'. count how many items fall into each category.

with new_table
	as
	(
select 
	*,
	case
	when 
	   description ilike '%Kill%' or 
	   description ilike '%Violence%' then 'Bad_content'
	   else 'Good_content' 
	end category
from netflix
)
select category,
count(*) as total_content
from new_table
group by 1;




























	




































