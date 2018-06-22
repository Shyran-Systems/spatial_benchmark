\timing on

DROP TABLE test_haversine;

-- Tables
CREATE TABLE test_haversine (id INT, ra FLOAT, dec FLOAT);

-- -- Random data
-- INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series(1,1000000), random()*360, acos(1-2*random())/pi()*180-90);

-- Indices
-- CREATE INDEX test_haversine_ra_idx ON test_haversine (ra);
CREATE INDEX test_haversine_dec_idx ON test_haversine (dec);

VACUUM ANALYZE;
