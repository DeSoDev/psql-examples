WITH RecentFollowes AS (
SELECT 
    t.public_key pubkey,
    age(current_timestamp,to_timestamp(MAX(b.timestamp))) LastFollowed,
    MAX(b.height) LastHeight,
    SUM(CASE WHEN f.is_unfollow THEN -1 ELSE 1 END)=1 StillFollows,
    count(*) as number
FROM pg_metadata_follows f
JOIN pg_transactions t ON t.hash = f.transaction_hash
JOIN pg_blocks b ON b.hash=t.block_hash
WHERE 
    f.followed_public_key='\x02a9192d6d3fdf38347606e58e96960b4126b6f3c1fb53244032700cdc97a00b18'
GROUP BY t.public_key
ORDER BY LastFollowed ASC
)
SELECT 
    convert_from(p.profile_pic, 'UTF-8') pfp,
    p.username username,
    LastFollowed,
    p.Description Info,
    p.de_so_locked_nanos/1e9 DesoLocked,
    number_of_holders Holders
FROM RecentFollowes f
JOIN pg_profiles p ON p.pkid = f.pubkey
WHERE 
    f.StillFollows and
    number_of_holders > 0 and
    description<>''