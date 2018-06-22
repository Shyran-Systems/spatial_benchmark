\timing on

DROP TABLE test_q3c;
DROP TABLE test_pgsphere;

-- Tables
CREATE TABLE test_q3c (id INT, ra FLOAT, dec FLOAT);
CREATE TABLE test_pgsphere (id INT, point spoint);

-- Random data
INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series(1,1000000), random()*360, acos(1-2*random())/pi()*180-90);
INSERT INTO test_pgsphere (id, point) (SELECT generate_series(1,1000000), spoint(random()*2*pi(), acos(1-2*random())-pi()/2));

-- Indices
CREATE INDEX test_q3c_idx ON test_q3c (q3c_ang2ipix(ra,dec));
CREATE INDEX test_pgsphere_idx ON test_pgsphere USING gist(point);

VACUUM ANALYZE;



-- DROP TABLE test_q3c;
-- CREATE TABLE test_q3c (id INT, ra FLOAT, dec FLOAT);
-- INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series(1,100000), random()*360, acos(1-2*random())/pi()*180-90);
-- CREATE INDEX test_q3c_idx ON test_q3c (q3c_ang2ipix(ra,dec));
-- VACUUM ANALYZE;
