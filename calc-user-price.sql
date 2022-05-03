/*
coinPriceDeSoNanos = DeSoLockedNanos / (CoinsInCirculationNanos * ReserveRatio) * NanosPerUnit
from: 
- https://github.com/deso-protocol/backend/blob/b326278f8fb0786a7a8f2460fac8700219dc89c2/routes/user.go#L865
- https://github.com/deso-protocol/core/blob/2acd49e66c12d4c42dc325206cd0c0e73c03e2c7/lib/constants.go#L583

bigNanosPerUnit = NanosPerUnit  = 1,000,000,000 = 1e9
DeSoLocked = DeSoLockedNanos / bigNanosPerUnit
CoinsInCirculation = CoinsInCirculationNanos / bigNanosPerUnit
CreatorCoinReserveRatio = 0.3333333

coinPriceDeSoNanos = DeSoLocked / ( CoinsInCirculation * CreatorCoinReserveRatio ) * NanosPerUnit
*/

SELECT 
username, 
de_so_locked_nanos/1e9 DesoLocked,  
coins_in_circulation_nanos/1e9 CreatorCirculation, 
{{ DESOUSD }} * ( de_so_locked_nanos / 1e9 ) / ( ( coins_in_circulation_nanos / 1e9 ) * 0.3333333) price
FROM pg_profiles 
WHERE username IN ('dharmesh','tijn', 'cloutpunk', 'diamondhands', 'nader', 'spookies')