SELECT UNNEST(regexp_matches(BODY,'[\U0001F300-\U0001F6FF]')) emoji,
       COUNT(*) cnt
FROM pg_posts
WHERE BODY ~ '[\U0001F300-\U0001F6FF]'
GROUP BY emoji
ORDER BY cnt DESC
LIMIT 25;

