\timing on

DROP TABLE test_q3c;

-- Tables
CREATE TABLE test_q3c (id INT, ra FLOAT, dec FLOAT);

-- -- Random data
-- INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series(1,1000000), random()*360, acos(1-2*random())/pi()*180-90);

-- Indices
CREATE INDEX test_q3c_idx ON test_q3c (q3c_ang2ipix(ra,dec));

VACUUM ANALYZE;
