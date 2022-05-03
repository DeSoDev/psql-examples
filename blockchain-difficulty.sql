create or replace function hex_to_bigint(hexval text) returns bigint as $$
select
(get_byte(x,0)::int8<<(7*8)) |
(get_byte(x,1)::int8<<(6*8)) |
(get_byte(x,2)::int8<<(5*8)) |
(get_byte(x,3)::int8<<(4*8)) |
(get_byte(x,4)::int8<<(3*8)) |
(get_byte(x,5)::int8<<(2*8)) |
(get_byte(x,6)::int8<<(1*8)) |
(get_byte(x,7)::int8)
from (
select decode(lpad($1, 16, '0'), 'hex') as x
) as a;
$$
language sql strict immutable;

with diff AS (select 
min(height) height,
min(to_timestamp(timestamp)) ts,
floor(height/288) retarget_seq,
encode(difficulty_target,'hex') difftarget,
count(*),
MIN(LENGTH((regexp_match(encode(difficulty_target,'hex')::text,'0*'))[1])) diff
from pg_blocks 
where height % 288 = 0
group by difftarget,retarget_seq
order by height asc)

SELECT hex_to_bigint(difftarget),* FROM diff;