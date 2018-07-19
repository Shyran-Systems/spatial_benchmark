#!/usr/bin/env perl

use strict;
use warnings;

use DBI;
use JSON;
use Math::Trig;
use Getopt::Std;
use Data::Dumper;

$| = 1;

my $db = 'test_match';
my $port = 5432;
my $type = 'q3c';
my $sr = 1.0/3600;
my $idx = 0;

# -d for database name
# -p for database port
# -s for match radius
# -t for index type
# -i for spoint2
my %opt = ();
getopts('d:p:n:m:t:i',\%opt);

if(defined $opt{d}){
  $db = $opt{d}
}
if(defined $opt{p}){
  $port = $opt{p}
}
if(defined $opt{t}){
  $type = $opt{t};
}
if(defined $opt{s}){
  $sr = $opt{s}
}
if(defined $opt{i}){
  $idx = 1;
}

print STDERR "db=".$db." at port ".$port.", index=".$type.",  sr=".$sr.", idx=".$idx."\n";

my $dbh = DBI->connect("dbi:Pg:dbname=$db host=localhost port=$port");
$dbh->{pg_server_prepare} = 0;

sub get_statio($){
  my ($type) = @_;
  my $name;

  if($type eq "pg"){
    $name = "test_pgsphere";
  } elsif($type eq 'q3c'){
    $name = "test_q3c";
  } elsif($type eq 'haversine'){
    $name = "test_haversine";
  } elsif($type eq 'postgis'){
    $name = "test_postgis";
  }

  my $q = "SELECT heap_blks_read, heap_blks_hit, idx_blks_read, idx_blks_hit FROM pg_statio_all_tables WHERE relname = '".$name."';";
  my $qr = $dbh->prepare($q);
  $qr->execute() or die "Error processing query: ".$dbh->errstr . "\n";

  my @res = $qr->fetchrow_array();

  $qr->finish();

  return @res;
}

sub make_query($$){
  my ($dbh, $q) = @_;

  print STDERR $q."\n";

  # return;

  my $qr = $dbh->prepare($q);
  $qr->execute() or die "Error processing query: ".$dbh->errstr . "\n";

  $qr->finish();
}

for(my $d = 1; $d <= 7; $d+=0.3){
  my $q = "";
  my $N = int(10**$d + 0.99);
  my @h;

  print STDERR $d." / 8, $N\n";

  make_query($dbh, "DROP TABLE IF EXISTS test;");
  #make_query($dbh, "DROP INDEX IF EXISTS test_idx;");
  if($type eq 'pg'){
    make_query($dbh, "CREATE TABLE test (id INT, point spoint);");
    make_query($dbh, "INSERT INTO test (id, point) (SELECT generate_series(1, $N), spoint(random()*2*pi(), acos(1-2*random())-pi()/2));");
    make_query($dbh, "CREATE INDEX test_idx ON test USING gist(point spoint2);");
  } elsif($type eq 'q3c'){
    make_query($dbh, "CREATE TABLE test (id INT, ra FLOAT, dec FLOAT);");
    make_query($dbh, "INSERT INTO test (id, ra, dec) (SELECT generate_series(1, $N), random()*360, acos(1-2*random())/pi()*180-90);");
    make_query($dbh, "CREATE INDEX test_idx ON test (q3c_ang2ipix(ra,dec));");
  } elsif($type eq 'haversine'){
    make_query($dbh, "CREATE TABLE test (id INT, ra FLOAT, dec FLOAT);");
    make_query($dbh, "INSERT INTO test (id, ra, dec) (SELECT generate_series(1, $N), random()*360, acos(1-2*random())/pi()*180-90);");
    #make_query($dbh, "CREATE INDEX test_ra_idx ON test (ra);");
    make_query($dbh, "CREATE INDEX test_dec_idx ON test (dec);");
  } elsif($type eq 'postgis'){
    make_query($dbh, "CREATE TABLE test (id INT, point geography(POINT, 4326));");
    make_query($dbh, "INSERT INTO test (id, point) (SELECT generate_series(1, $N), st_geographyfromtext(concat('POINT(', random()*360-180, ' ', acos(1-2*random())/pi()*180-90, ')')));");
    make_query($dbh, "CREATE INDEX test_idx ON test USING gist(point);");
  }

  make_query($dbh, "VACUUM ANALYZE;");

  my @stats0 = get_statio($type);

  if($type eq 'pg') {
    if($idx eq 1){
      $q = "SELECT count(*) FROM crossmatch('test_pgsphere_idx', 'test_idx', ".($sr*pi/180).") as (id1 tid, id2 tid);";
    } else {
      $q = "SELECT count(*) FROM test a, test_pgsphere b WHERE b.point @ scircle(a.point, 1.0/3600*pi()/180);";
    }
  } elsif($type eq 'q3c'){
    $q = "SELECT count(*) FROM test as a, test_q3c as b WHERE q3c_join(a.ra, a.dec, b.ra, b.dec, $sr);";
  } elsif($type eq 'haversine'){
    $q = "SELECT count(*) FROM test as a, test_q3c as b WHERE b.dec between a.dec-$sr and a.dec+$sr and
(sin(radians(b.dec-a.dec)/2)^2 + cos(radians(a.dec))*cos(radians(b.dec))*sin(radians(b.ra-a.ra)/2)^2
      <
  sin(radians($sr)/2)^2);";
  } elsif($type eq 'postgis'){
  $q = "select count(*) from test a, test_postgis b where st_dwithin(a.point, b.point,
                                                           ".(111195.0792*$sr).",
                                                           false)";
  }

  print STDERR $q."\n";

  $q = "EXPLAIN (ANALYZE ON, BUFFERS ON, FORMAT JSON) ".$q;

  my $qr = $dbh->prepare($q);
  $qr->execute() or die "Error processing query: ".$dbh->errstr . "\n";
  my ($json) = $qr->fetchrow_array();

  @h = @{decode_json($json)};

  $qr->finish();

  my $planning_time = $h[0]->{'Planning Time'};
  my $execution_time = $h[0]->{'Execution Time'};
  my $time = $execution_time;
  my $blks_read = $h[0]->{'Plan'}->{'Shared Read Blocks'};
  my $blks_hit = $h[0]->{'Plan'}->{'Shared Hit Blocks'};
  my $ntuples = $h[0]->{'Plan'}->{'Plans'}[0]->{'Actual Rows'};

  my @stats1 = get_statio($type);

  # while($stats0[0] eq $stats1[0] and
  #       $stats0[1] eq $stats1[1] and
  #       $stats0[2] eq $stats1[2] and
  #       $stats0[3] eq $stats1[3]){
{
    @stats1 = get_statio($type);
  }

  my ($heap_blks_read, $heap_blks_hit, $idx_blks_read, $idx_blks_hit) = map {$stats1[$_] - $stats0[$_]} keys @stats0;

  print "$time $N $sr $heap_blks_read $heap_blks_hit $idx_blks_read $idx_blks_hit\n";
}
