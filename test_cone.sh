#!/bin/bash

TEST_RUNNING=test_running

dropdb test_q3c
createdb test_q3c
echo 'CREATE EXTENSION q3c;' | psql test_q3c
psql test_q3c < ${TEST_RUNNING}.q3c.sql >/dev/null 2>/dev/null
echo "q3c"
./test_cone.pl -d test_q3c -t q3c -n 1000 -m 10 > out_cone_q3c_c_1000_10
dropdb test_q3c

dropdb test_pg
createdb test_pg
echo 'CREATE EXTENSION pg_sphere;' | psql test_pg
psql test_pg < ${TEST_RUNNING}.pg.sql >/dev/null 2>/dev/null
echo "pg"
./test_cone.pl -d test_pg -t pg -n 1000 -m 10 > out_cone_pg_c_1000_10
dropdb test_pg

dropdb test_haversine
createdb test_haversine
psql test_haversine < ${TEST_RUNNING}.haversine.sql >/dev/null 2>/dev/null
echo "haversine"
./test_cone.pl -d test_haversine -t haversine -n 1000 -m 10 > out_cone_haversine_c_1000_10
dropdb test_haversine

dropdb test_postgis
createdb test_postgis
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.4/postgis.sql >/dev/null 2>/dev/null
psql test_postgis < `pg_config --sharedir`/contrib/postgis-2.4/spatial_ref_sys.sql
psql test_postgis < ${TEST_RUNNING}.postgis.sql >/dev/null 2>/dev/null
echo "postgis"
./test_cone.pl -d test_postgis -t postgis -n 1000 -m 10 > out_cone_postgis_c_1000_10
dropdb test_postgis
