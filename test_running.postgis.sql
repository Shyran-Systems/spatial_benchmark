\timing on

DROP TABLE test_postgis;

-- Tables
CREATE TABLE test_postgis (id INT, point geography(POINT, 4326));

-- -- Random data
-- INSERT INTO test_postgis (id, point) (SELECT generate_series(1,1000000), st_geographyfromtext(concat('POINT(', random()*360-180, ' ', acos(1-2*random())/pi()*180-90, ')')));

-- Indices
CREATE INDEX test_postgis_idx ON test_postgis USING gist(point);

VACUUM ANALYZE;
