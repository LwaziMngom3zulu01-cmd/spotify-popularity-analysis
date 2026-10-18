SELECT * FROM tracks LIMIT10;
SELECT count(*) FROM tracks;

--Q1 Average popularity by genre
SELECT track_genre, round(avg(popularity),1) as avg_popularity 
FROM tracks
group by track_genre
order by avg_popularity DESC
limit 10;

--Q2 explicit vs non-explicit popularity
SELECT explicit, count(*) as num_songs, round(avg(popularity),1) as avg_popularity
FROM tracks
group by explicit;

SELECT
CASE
WHEN energy < 0.33 then 'Low energy'
when energy < 0.66 then 'Medium energy'
else 'High energy'
END as energy_level,
count(*) as num_songs,
round(avg(popularity),1) as avg_popularity
from tracks
group by energy_level
order by avg_popularity DESC;

SELECT
CASE
WHEN valence< 0.33 THEN 'Sad/negative'
WHEN valence< 0.66 THEN 'Nuetral'
else 'Happy/positive'
end as mood,
count(*) as num_songs,
round(avg(popularity),1) as avg_popularity
from tracks
group by mood
order by avg_popularity desc;

SELECT count(*) as total_rows, count(DISTINCT track_id) as unique_tracks
from tracks;

SELECT track_id, track_name, artists, popularity, track_genre
FROM tracks
WHERE track_id in (
SELECT track_id FROM tracks
GROUP by track_id
HAVING count(*)>1
)
ORDER by track_id
LIMIT 20;

CREATE TABLE tracks_clean as
SELECT *, max(popularity) as max_popularity
FROM tracks
GROUP by track_id;

SELECT count(*) as total_rows, count(DISTINCT track_id) as unique_tracks
FROM tracks_clean;

SELECT explicit, count(*) as num_songs, round(avg(popularity),1) as avg_popularity
FROM tracks_clean
group by explicit;

SELECT
  track_genre,
  SUM(CASE WHEN LOWER(explicit) = 'true' THEN 1 ELSE 0 END) AS explicit_songs,
  ROUND(AVG(CASE WHEN LOWER(explicit) = 'true' THEN popularity END), 1) AS explicit_avg,
  ROUND(AVG(CASE WHEN LOWER(explicit) = 'false' THEN popularity END), 1) AS non_explicit_avg
FROM tracks_clean
GROUP BY track_genre
HAVING explicit_songs >= 30
ORDER BY explicit_songs DESC
LIMIT 15;

SELECT
CASE
WHEN energy < 0.33 then 'Low energy'
when energy < 0.66 then 'Medium energy'
else 'High energy'
END as energy_level,
count(*) as num_songs,
round(avg(popularity),1) as avg_popularity
from tracks_clean
group by energy_level
order by avg_popularity DESC;

SELECT
CASE
WHEN valence< 0.33 THEN 'Sad/negative'
WHEN valence< 0.66 THEN 'Nuetral'
else 'Happy/positive'
end as mood,
count(*) as num_songs,
round(avg(popularity),1) as avg_popularity
from tracks_clean
group by mood
order by avg_popularity desc;