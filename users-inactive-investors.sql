WITH 
    UserKey AS (
        SELECT pkid FROM pg_profiles WHERE username='tijn'
    ),
    LastPosts AS (
        SELECT poster_public_key, count(*) posts, to_timestamp(MAX(timestamp)/1e9) lastPost FROM pg_posts WHERE age(current_timestamp,to_timestamp(timestamp/1e9)) <= interval '90 day' GROUP BY poster_public_key ORDER BY lastPost DESC
    ),
    Investments AS (
        SELECT 
            p.username CreatorCoin, 
            b.balance_nanos/1e9 CoinBalance,
            posts.posts posts,
            posts.lastPost lastPost
        FROM pg_creator_coin_balances b
        JOIN pg_profiles p ON p.pkid=b.holder_pkid
        LEFT JOIN LastPosts posts ON posts.poster_public_key = b.holder_pkid
        WHERE 
            b.creator_pkid=(SELECT pkid FROM UserKey LIMIT 1)
            AND b.balance_nanos > 0
            AND b.creator_pkid<>b.holder_pkid
        ORDER BY CoinBalance DESC
    )
SELECT *, age(current_timestamp,lastPost) inactiveTime 
FROM Investments 
WHERE CoinBalance > 0
ORDER BY CoinBalance DESC
