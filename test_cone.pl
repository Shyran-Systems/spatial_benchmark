#!/usr/bin/env perl -w

use strict;

use DBI;
use JSON;
use Math::Trig;
use Getopt::Std;
use Data::Dumper;

$| = 1;

my $db = 'q3c';
my $port = 5432;
my $type = 'q3c';
my $nqueries = 100;
my $min_sr = 0.01;
my $max_sr = 10.0;

# -d for database name
# -p for database port
# -n for number of queries to issue
# -m for max query radius
# -t for index type
my %opt = ();
getopts('d:p:n:m:t:',\%opt);

if(defined $opt{d}){
  $db = $opt{d}
}
if(defined $opt{p}){
  $port = $opt{p}
}
if(defined $opt{t}){
  $type = $opt{t};
}
if(defined $opt{m}){
  $max_sr = $opt{m}
}
if(defined $opt{n}){
  $nqueries = $opt{n}
}

print STDERR "db=".$db." at port ".$port.", index=".$type.",  Nqueries=".$nqueries.", max_sr=".$max_sr."\n";

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

for(my $d = 0; $d < $nqueries; $d++){
  my $sr0 = exp(log($min_sr) + (log($max_sr)-log($min_sr))*rand());
  my $ra0 = 360*rand();
  my $dec0 = acos(1-2*rand())*180.0/pi-90;
  my $q = "";
  my @h;

  my @stats0 = get_statio($type);

  if ($type eq 'pg') {
    $q = "SELECT count(*) FROM test_pgsphere WHERE point @ scircle(spoint(".($ra0*pi/180).", ".($dec0*pi/180)."), ".($sr0*pi/180).");";
  } elsif ($type eq 'q3c') {
    $q = "SELECT count(*) FROM test_q3c WHERE q3c_radial_query(ra, dec, $ra0, $dec0, $sr0);";
  } elsif ($type eq 'haversine') {
    $q = "SELECT count(*) from test_haversine b WHERE
 b.dec between $dec0 - $sr0 and $dec0 + $sr0 and
(sin(radians(b.dec - $dec0)/2)^2 + cos(radians($dec0))*cos(radians(b.dec))*sin(radians(b.ra - $ra0)/2)^2
 <
 sin(radians($sr0)/2)^2);";
  } elsif ($type eq 'postgis') {
  $q = "select count(*) from test_postgis where st_dwithin(point, st_geographyfromtext(concat('POINT(', $ra0-180, ' ', $dec0, ')')),
                                                           ".(111195.0792*$sr0).",
                                                           false)";
}

  $q = "EXPLAIN (ANALYZE ON, BUFFERS ON, FORMAT JSON) ".$q;

  print STDERR "$d/$nqueries sr0=$sr0 ra0=$ra0 dec0=$dec0\n";
  #print STDERR $q."\n";

  my $qr = $dbh->prepare($q);
  $qr->execute() or die "Error processing query: ".$dbh->errstr . "\n";
  my ($json) = $qr->fetchrow_array();

  @h = @{decode_json($json)};

  $qr->finish();

  #  print Dumper(@h);

  my $time = $h[0]->{'Total Runtime'};
  my $blks_read = $h[0]->{'Plan'}->{'Shared Read Blocks'};
  my $blks_hit = $h[0]->{'Plan'}->{'Shared Hit Blocks'};
  my $ntuples = $h[0]->{'Plan'}->{'Plans'}[0]->{'Actual Rows'};

  #print STDERR Dumper(@stats0)."\n";

  my @stats1 = get_statio($type);

  while($stats0[0] eq $stats1[0] and
        $stats0[1] eq $stats1[1] and
        $stats0[2] eq $stats1[2] and
        $stats0[3] eq $stats1[3]){
    @stats1 = get_statio($type);
  }

  #print STDERR Dumper(@stats1)."\n\n";

  my ($heap_blks_read, $heap_blks_hit, $idx_blks_read, $idx_blks_hit) = map {$stats1[$_] - $stats0[$_]} keys @stats0;

  #print "$time $ntuples $blks_read $blks_hit ".($blks_read+$blks_hit)." $sr0 $ra0 $dec0\n";

  print "$time $ntuples $sr0 $heap_blks_read $heap_blks_hit $idx_blks_read $idx_blks_hit\n";
}
