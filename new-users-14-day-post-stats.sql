WITH UserPostStats AS (
    SELECT 
        poster_public_key pubkey, 
        to_timestamp(MIN(timestamp/1e9)) firstPost,
        to_timestamp(MAX(timestamp/1e9)) lastPost,
    	max(age(current_timestamp,to_timestamp(timestamp/1e9))) max_age,
    	min(age(current_timestamp,to_timestamp(timestamp/1e9))) min_age,
    	max(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) max_hours,
    	min(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) min_hours,
        count(*) all_posts,
	    count(*) FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '7 day') posts_7day,
		count(*) FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '3 day') posts_3day,
    	count(*) FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '1 day') posts_1day,
    	sum( (20*diamond_count+10*quote_repost_count+5*comment_count+like_count+repost_count)/(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) ) engagements,
    	sum( (20*diamond_count+10*quote_repost_count+5*comment_count+like_count+repost_count)/(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) )  FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '7 day') engagement_7day,
    	sum( (20*diamond_count+10*quote_repost_count+5*comment_count+like_count+repost_count)/(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) )  FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '3 day') engagement_3day,
    	sum( (20*diamond_count+10*quote_repost_count+5*comment_count+like_count+repost_count)/(ceil(extract('epoch' from age(current_timestamp,to_timestamp(timestamp/1e9)))/3600)) )  FILTER (WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= '1 day') engagement_1day
    FROM pg_posts 
    GROUP BY poster_public_key 
    ORDER BY firstPost DESC
)
SELECT 
    u.username, 
    u.description,
    number_of_holders,
    de_so_locked_nanos/1e9 deso_locked,
    engagements/all_posts eng_post,
    engagement_7day/posts_7day eng_post_7day,
    engagement_3day/posts_3day eng_post_3day,
    engagement_1day/posts_1day eng_post_1day,
    p.*,
    age(current_timestamp,firstPost) firstPostTime,
    age(current_timestamp,lastPost) lastPostTime
FROM UserPostStats p 
JOIN pg_profiles u ON u.public_key = p.pubkey
WHERE posts_7day>3 AND posts_3day>0 AND posts_1day>0 AND age(firstPost) <= '14 day'
ORDER BY all_posts DESC
