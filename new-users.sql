WITH new_users AS (
  SELECT 
  	MIN(b.height) minHeight,
  	to_timestamp(MIN(b.timestamp)) Dt,
  	COUNT(*) updates,
  	t.public_key pkey 
  FROM pg_transactions t
  LEFT JOIN pg_blocks b ON b.hash=t.block_hash
  WHERE t.type=6
  GROUP BY pkey
  ORDER BY minHeight DESC
  LIMIT 100
)
SELECT 
    dt FirstUpdated, 
    updates ProfileUpdates, 
    convert_from(profile_pic, 'UTF-8') profilepic,
    username,
    encode(public_key,'hex') pubkey,
    description,
    number_of_holders,
    de_so_locked_nanos/1e9 desoLocked,
    coins_in_circulation_nanos/1e9 circulation
FROM new_users  u
LEFT JOIN pg_profiles p ON p.pkid=u.pkey
WHERE username IS NOT NULL