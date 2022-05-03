WITH 
    TotalFollowers AS (
        SELECT followed_pkid pkid, COUNT(*) Followers FROM pg_follows GROUP BY followed_pkid ORDER BY Followers DESC
    ),
    Tx30d AS (
        SELECT 
        	t.public_key pkey, count(*) actions 
        FROM pg_blocks b 
        JOIN pg_transactions t ON t.block_hash=b.hash
        WHERE 
        	t.type IN (4,5,9,10,15,18)
           AND to_timestamp(b.timestamp) >= ( current_date - interval '30 day' )
        GROUP BY t.public_key
    ),
    UsersActiveFollower AS (
        SELECT
        f2.followed_pkid pkid, count(*) MAF
        FROM tx30d f1
        JOIN pg_follows f2 ON f1.pkey=f2.follower_pkid
        GROUP BY f2.followed_pkid
    )
SELECT af.pkid,p.username, MAF, tf.Followers-MAF InActive, tf.Followers Total, 100*(tf.Followers-MAF)/tf.Followers inactive_perc FROM UsersActiveFollower af
JOIN pg_profiles p ON p.pkid=af.pkid
JOIN TotalFollowers tf ON tf.pkid=af.pkid
 ORDER BY MAF DESC