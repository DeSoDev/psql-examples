-- how to create hex key for user prior to Base58

SELECT 
    -- source the public_key for user (output as hex text)
    public_key::text,

    -- append prefix to public key, output as hex text
    ('\xcd1400' || public_key)::text,

    -- create checksum (first 4 bytes of double sha256)
    substring(sha256(sha256('\xcd1400' || public_key)) FOR 4)::text,

    -- create full hex value to base58, of course remove the \x
    encode('\xcd1400' || public_key || substring(sha256(sha256('\xcd1400' || public_key)) FOR 4),'hex') fullHex
    
FROM pg_profiles WHERE username='tijn';


-- decode hex after base58

SELECT 
    -- get the relevant hex from the full base58 decoded hex
    substring('cd140002a9192d6d3fdf38347606e58e96960b4126b6f3c1fb53244032700cdc97a00b18a1abc32d' FROM 7 FOR 66),
    
    -- get it as bytea
    decode(substring('cd140002a9192d6d3fdf38347606e58e96960b4126b6f3c1fb53244032700cdc97a00b18a1abc32d' FROM 7 FOR 66),'hex'),

    -- compare to the stored value
    public_key=decode(substring('cd140002a9192d6d3fdf38347606e58e96960b4126b6f3c1fb53244032700cdc97a00b18a1abc32d' FROM 7 FOR 66),'hex') DoesItMatch
FROM pg_profiles WHERE username='tijn';