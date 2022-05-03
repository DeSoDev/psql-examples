SELECT 
    username, 
    body::json->'VideoURLs'->0 video,
    to_timestamp(timestamp/1e9) dt,
    diamond_count, 
    repost_count, 
    like_count, 
    quote_repost_count, 
    encode(post_hash,'hex') post
FROM pg_posts post
JOIN pg_profiles prof ON post.poster_public_key=prof.public_key
WHERE 
body LIKE '%videodelivery%'
ORDER BY diamond_count DESC