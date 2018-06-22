\timing on

DROP TABLE test_pgsphere;

-- Tables
CREATE TABLE test_pgsphere (id INT, point spoint);

-- -- Random data
-- INSERT INTO test_pgsphere (id, point) (SELECT generate_series(1,1000000), spoint(random()*2*pi(), acos(1-2*random())-pi()/2));

-- Indices
CREATE INDEX test_pgsphere_idx ON test_pgsphere USING gist(point);

VACUUM ANALYZE;
