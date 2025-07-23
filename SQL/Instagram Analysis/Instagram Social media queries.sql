
SELECT users.username, users.id, COUNT(photos.id) AS photos_posted, users.created_at
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY users.created_at 
LIMIT 10;

SELECT EXTRACT (HOUR from created_at) as hour, COUNT(*) AS activity
FROM (
    SELECT created_at FROM Likes
    UNION ALL
    SELECT created_at FROM Comments
    UNION ALL
    SELECT created_at FROM Photos) AS pr
GROUP BY hour	
ORDER BY activity DESC;



SELECT EXTRACT (HOUR from created_at) as hour_of_day, day_of_week, COUNT(*) AS activity
FROM (
    SELECT created_at, day_of_week FROM Likes
    UNION ALL
    SELECT created_at, day_of_week FROM Comments
    UNION ALL
    SELECT created_at, day_of_week FROM Photos) AS pr
GROUP BY hour_of_day, day_of_week	
ORDER BY activity DESC;

SELECT MAX(created_at) FROM (
    SELECT created_at FROM photos
    UNION ALL
    SELECT created_at FROM comments
    UNION ALL
    SELECT created_at FROM likes
    UNION ALL
    SELECT created_at FROM follows
) AS all_activity;

SELECT DISTINCT user_id
FROM (
    SELECT user_id, created_at FROM photos WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
    UNION
    SELECT user_id, created_at FROM comments WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
    UNION
    SELECT user_id, created_at FROM likes WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
    UNION
    SELECT follower_id AS user_id, created_at FROM follows WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
) recent_activity;

SELECT id, username, created_at
FROM users
WHERE id NOT IN (
    SELECT DISTINCT user_id
    FROM (
        SELECT user_id FROM photos WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
        UNION
        SELECT user_id FROM comments WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
        UNION
        SELECT user_id FROM likes WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
        UNION
        SELECT follower_id AS user_id FROM follows WHERE created_at > DATE '2017-05-04' - INTERVAL '30 days'
    ) AS recent_activity
);

SELECT p.user_id, u.username, p.id AS photo_id, COUNT(l.user_id) AS likes_count
FROM photos AS p
JOIN likes AS l ON p.id = l.photo_id
JOIN users AS u ON u.id = p.user_id
GROUP BY p.user_id, u.username, p.id
ORDER BY likes_count DESC
LIMIT 10;

SELECT 
  u.id AS user_id,
  u.username,
  COUNT(p.id) AS total_photos
FROM users AS u
JOIN photos AS p ON u.id = p.user_id
GROUP BY u.id, u.username
ORDER BY total_photos DESC;

SELECT ROUND(AVG(photo_count),2) AS average_posts
FROM(
SELECT user_id, COUNT(p.id) AS photo_count
FROM photos AS p
GROUP BY user_id
) AS user_photo_counts;

SELECT EXTRACT(YEAR FROM created_at) AS year,
       TO_CHAR (created_at, 'Month') AS month,
COUNT(*) AS photos_posted
FROM photos
GROUP BY year,month
ORDER BY photos_posted DESC;

SELECT EXTRACT(YEAR FROM created_at) AS year,
       TO_CHAR (created_at, 'Month') AS month, 
	   30 as monthly_target, COUNT(*) AS photos_posted,
CASE 
    WHEN COUNT(*) >= 30 THEN 'Target Met' ELSE 'Below Target' END AS performance
FROM photos
GROUP BY year,month
ORDER BY photos_posted DESC;

SELECT COUNT(DISTINCT user_id) AS users_with_posts
FROM photos;

SELECT tags.tag_name, COUNT(*) AS usage_count
FROM tags
JOIN photos_tags ON photos_tags.tag_id = tags.id
GROUP BY tag_name
ORDER BY usage_count DESC;

SELECT l.user_id, u.username, COUNT (*) AS total_likes
FROM likes AS l
JOIN users AS u ON l.user_id = u.id
GROUP BY l.user_id, u.username 
HAVING COUNT (*) = (
                       SELECT COUNT(*)
                       FROM photos)
;

SELECT u.id,u.username, COUNT(*)  AS total_follows
FROM follows AS f
JOIN users AS u ON f.followee_id = u.id
GROUP BY u.username, u.id
ORDER BY total_follows DESC;