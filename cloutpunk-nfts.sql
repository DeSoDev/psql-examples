SELECT 
    b.height,
    to_timestamp(b.timestamp) minted,
    p.body::json->'Body' postBody,
    p.body::json->'ImageURLs'->>0 imageUrl,
    n.nft_post_hash postHash,
    n.for_sale,
    n.min_bid_amount_nanos/1e9 minBid,
    n.last_accepted_bid_amount_nanos/1e9 floor 
FROM pg_transactions t 
    JOIN pg_metadata_create_nfts cn ON t.hash=cn.transaction_hash
    JOIN pg_nfts n ON cn.nft_post_hash=n.nft_post_hash
    JOIN pg_blocks b ON b.hash=t.block_hash
    JOIN pg_posts p ON p.post_hash=n.nft_post_hash
WHERE 
	t.type=15 AND 
    t.public_key='\x03a9a1d24571bf6cfe648df03e5e5761388fae0d874beba5669485349052f41333'
    AND (
        '{{ showforsale }}'='All' OR
        ('{{ showforsale }}'='Yes' AND n.for_sale=true) OR 
        ('{{ showforsale }}'='No' AND n.for_sale=false)
    )
ORDER BY last_accepted_bid_amount_nanos DESC