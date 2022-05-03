SELECT to_timestamp(TIMESTAMP/1e9)::date dt,
       count(parent_post_hash IS NULL OR NULL) totPosts,
       count(parent_post_hash) totReplies,
       sum(comment_count) totComments,
       sum(like_count) totLikes,
       sum(diamond_count) totDiamonds,
       sum(repost_count) totReclouts,
       sum(quote_repost_count) totQuotes,
       sum(num_nft_copies) totNfts,
       count(hidden OR NULL) totHidden,
       count(pinned OR NULL) totPinned,
       count(unlockable OR NULL) totUnlockable,
       avg(length(body)) max_length
FROM pg_posts
GROUP BY dt
ORDER BY dt DESC
LIMIT 90