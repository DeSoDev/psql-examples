SELECT to_timestamp(TIMESTAMP/1e9),
       BODY,
       post_hash
FROM pg_posts
WHERE LOWER(BODY) LIKE '%brootle%'
  AND LOWER(BODY) NOT LIKE '%@brootle%'
ORDER BY TIMESTAMP DESC
LIMIT 20;