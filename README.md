# Spotify Music Popularity Analysis

An analysis of 114,000 Spotify tracks using **SQL** and **Power BI** to find out what songs have in common when they are popular.


<img width="725" height="421" alt="image" src="https://github.com/user-attachments/assets/9d119cea-625a-425e-aa4b-ed5371301643" />



## Questions I wanted to answer

1. Which genres have the highest average popularity?
2. Are explicit songs more popular than non-explicit songs?
3. Does a song's energy level relate to its popularity?
4. Do happier-sounding songs score higher than sadder ones?

## Data

- **Source:** the "Spotify Tracks Dataset" on Kaggle (114,000 rows, 21 columns, 125 genres)
- Columns used: `track_id`, `track_genre`, `popularity` (0-100), `explicit`, `energy`, `valence`
- The raw CSV is not included in this repo. Download it from Kaggle to reproduce the analysis.

## Tools

- DB Browser for SQLite (SQL queries and data cleaning)
- Power BI Desktop (dashboard)

## Method

1. Imported the CSV into a SQLite table called `tracks`.
2. **Checked for duplicates.** The table had 114,000 rows but only **89,741 unique `track_id`s**. The same song can be listed under several genres, and some copies of a song had a popularity of 0 while other copies had a high score.
3. Built a cleaned table, `tracks_clean`, with **one row per song**, keeping the copy with the highest popularity score (using `ROW_NUMBER()`).
4. Used `tracks_clean` for the song-level questions (explicit, energy, mood). Used the full `tracks` table for the genre ranking, so that a song stays in every genre it belongs to.
5. Grouped energy and valence into Low / Medium / High (or Sad / Neutral / Happy) bands using `CASE`, with cutoffs at 0.33 and 0.66.
6. Exported the query results as CSVs and built the dashboard in Power BI.

### Example queries

Removing duplicates:

```sql
CREATE TABLE tracks_clean AS
SELECT * FROM (
  SELECT *,
    ROW_NUMBER() OVER (
      PARTITION BY track_id
      ORDER BY popularity DESC
    ) AS rn
  FROM tracks
)
WHERE rn = 1;
```

Average popularity by energy band:

```sql
SELECT
  CASE
    WHEN energy < 0.33 THEN 'Low energy'
    WHEN energy < 0.66 THEN 'Medium energy'
    ELSE 'High energy'
  END AS energy_level,
  COUNT(*) AS num_songs,
  ROUND(AVG(popularity), 1) AS avg_popularity
FROM tracks_clean
GROUP BY energy_level
ORDER BY avg_popularity DESC;
```

All queries are in [`queries.sql`](queries.sql).

## Key findings

- **Explicit songs scored higher overall:** 36.9 average popularity vs 32.9 for non-explicit songs (89,741 unique songs).
- **But it is not universal.** Within the 15 genres with the most explicit songs, explicit songs scored higher in 10 and lower in 5. **Hip-hop was the biggest exception:** non-explicit songs scored about 51.5 vs about 24.7 for explicit songs.
- **Medium-energy songs had the highest average popularity**, and low-energy songs the lowest. It is not a simple "more energy = more popular" pattern.
- **Neutral-sounding songs scored highest, and happy-sounding songs scored lowest.**
- The differences in energy and mood are **modest** (a few points on a 0-100 scale).

## Limitations

- This shows **correlation, not cause**. For example, explicit songs may be popular partly because of the artists or genres they come from.
- Popularity is Spotify's own score for a single snapshot in time, and the dataset has no release year, so I could not look at change over time.
- "Keep the highest popularity" is my cleaning choice. A popularity of 0 on one copy of a song looked like a missing or stale score rather than a real one, but I did not confirm why it happens.
- The energy and mood band cutoffs (0.33 and 0.66) are my own choice. Different cutoffs could shift the numbers slightly.
- The genre ranking uses the full table, which still contains duplicate rows and some 0-popularity copies.
- The explicit comparison within genres only covers the 15 genres with enough explicit songs (30 or more).

## What I would do next

- Check how many songs each genre has, to see whether small genres distort the rankings.
- Repeat the energy and mood analysis within each genre.
- Try a dataset with release years to look at trends over time.
- Redo the analysis in Python (pandas) as a second project.

## Files

- `dashboard.png`: screenshot of the Power BI dashboard
- `queries.sql`: all SQL queries used
- `music_dashboard.pbix`: the Power BI file
- `results/`: CSV exports of the query results used in the dashboard

## Author

Lwazi Mngomezulu, Computer & Information Sciences student, Pretoria, South Africa
Portfolio: https://lwazi-dev.netlify.app/
