SELECT 
    p.body::json->'ImageURLs'->>0,p.extra_data::json->'EmbedVideoURL', 
    u.username Username,
    encode(post_hash,'hex') post
FROM pg_posts p
JOIN pg_profiles u ON u.public_key=p.poster_public_key
WHERE 
    reposted_post_hash='\x9a37a090ad31e1fb84af6a0cf31ec3b7d4db5a4647960ebcd9983a616c9536d2'
    AND p.hidden = false
    AND p.body::json->'ImageURLs'->>0<>''
ORDER BY (diamond_count*20+quote_repost_count*10+comment_count*5+like_count+repost_count)/(ceil(extract('epoch' FROM age(current_timestamp,to_timestamp(p.timestamp/1e9)))/3600)) DESC