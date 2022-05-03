SELECT convert_from(body,'SQL_ASCII')::json->'Body' body,convert_from(body,'SQL_ASCII')::json->'ImageURLs'->0 image,encode(p.post_hash_to_modify,'hex') posthash, to_timestamp(p.timestamp_nanos/1e9) dt
FROM pg_metadata_submit_posts p
JOIN pg_transactions t ON t.hash=p.transaction_hash
WHERE is_hidden AND t.public_key='\x034264e2e62ee8796cfa8466d3c0774106956e76ff38924b9e0e5758b6f9a1f3e6'
ORDER BY timestamp_nanos DESC