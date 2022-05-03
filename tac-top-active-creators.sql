-- Time decay: 0.5 ^ (age/halfTime)
-- With 12 hour half time: 
-- 1*power(0.5,(extract(epoch from age(current_timestamp,to_timestamp(b.timestamp)))/3600)/12) weighted

WITH Tx30d AS (
        SELECT 
        	t.public_key pkey, 
        	count(*) actions, 
        	max(b.timestamp) lastAction,
        	sum(1*power(0.5,(extract(epoch from age(current_timestamp,to_timestamp(b.timestamp)))/3600)/12)) weight
        FROM pg_blocks b 
        JOIN pg_transactions t ON t.block_hash=b.hash
        WHERE 
        	t.type IN (2,5,9,10,17,18,20)
           AND to_timestamp(b.timestamp) >= ( current_date - interval '7 day' )
        GROUP BY t.public_key
    )
SELECT 
    row_number() over (order by weight*de_so_locked_nanos/1e9 desc) rank,
    convert_from(profile_pic, 'UTF-8') profilepic,
    username, 
    de_so_locked_nanos/1e9 desoLocked,
    to_timestamp(lastAction) lastAction,
    actions,
    weight,
    weight*de_so_locked_nanos/1e9 score
FROM pg_profiles p 
JOIN Tx30d ON pkey = p.pkid
WHERE username IS NOT NULL AND de_so_locked_nanos > 0
ORDER BY score DESC 
LIMIT 100;