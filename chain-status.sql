SELECT 
Height Tip,
to_timestamp(timestamp) LastUpdate,
age(current_timestamp(0),to_timestamp(timestamp)) Age
FROM pg_blocks 
ORDER BY Height DESC LIMIT 1;