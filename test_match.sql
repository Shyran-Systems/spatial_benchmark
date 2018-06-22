CREATE TABLE test_q3c (id INT, ra FLOAT, dec FLOAT);
CREATE TABLE test_pgsphere (id INT, point spoint);
CREATE TABLE test_haversine (id INT, ra FLOAT, dec FLOAT);
CREATE TABLE test_postgis (id INT, point geography(POINT, 4326));

INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series(1,10000000), random()*360, acos(1-2*random())/pi()*180-90);
INSERT INTO test_pgsphere (id, point) (SELECT generate_series(1,10000000), spoint(random()*2*pi(), acos(1-2*random())-pi()/2));
INSERT INTO test_haversine (id, ra, dec) (SELECT generate_series(1,10000000), random()*360, acos(1-2*random())/pi()*180-90);
INSERT INTO test_postgis (id, point) (SELECT generate_series(1,10000000), st_geographyfromtext(concat('POINT(', random()*360-180, ' ', acos(1-2*random())/pi()*180-90, ')')));

CREATE INDEX test_q3c_idx ON test_q3c (q3c_ang2ipix(ra,dec));
CREATE INDEX test_pgsphere_idx ON test_pgsphere USING gist(point spoint2);
CREATE INDEX test_haversine_dec_idx ON test_haversine (dec);
CREATE INDEX test_postgis_idx ON test_postgis USING gist(point);

VACUUM ANALYZE;
