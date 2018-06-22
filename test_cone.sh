#!/bin/bash

#echo "CLUSTER test_q3c using test_q3c_idx;" | psql test_pg
echo "VACUUM ANALYZE;" | psql test_q3c
./test_cone.pl -d test_q3c -t q3c -n 1000 -m 10 > out_cone_q3c_c_1000_10

#echo "CLUSTER test_pgsphere using test_pgsphere_idx;" | psql test_pg
echo "VACUUM ANALYZE;" | psql test_pg
./test_cone.pl -d test_pg -t pg -n 1000 -m 10 > out_cone_pg_c_1000_10

#echo "CLUSTER test_pgsphere using test_pgsphere_idx;" | psql test_pg112
echo "VACUUM ANALYZE;" | psql test_pg112
./test_cone.pl -d test_pg112 -t pg -n 1000 -m 10 > out_cone_pg112_c_1000_10

#echo "CLUSTER test_pgsphere using test_pgsphere_idx;" | psql test_pg115
echo "VACUUM ANALYZE;" | psql test_pg115
./test_cone.pl -d test_pg115 -t pg -n 1000 -m 10 > out_cone_pg115_c_1000_10

#echo "CLUSTER test_haversine using test_haversine_dec_idx;" | psql test_haversine
echo "VACUUM ANALYZE;" | psql test_haversine
./test_cone.pl -d test_haversine -t haversine -n 1000 -m 10 > out_cone_haversine_c_1000_10

#echo "CLUSTER test_postgis using test_postgis_idx;" | psql test_postgis
echo "VACUUM ANALYZE;" | psql test_postgis
./test_cone.pl -d test_postgis -t postgis -n 1000 -m 10 > out_cone_postgis_c_1000_10
