#!/usr/bin/env perl

use strict;
use warnings;

use DBI;
use JSON;
use Math::Trig;
use Getopt::Std;
use Data::Dumper;

$| = 1;

my $db = 'test_q3c';
my $port = 5432;
my $type = 'q3c';
my $nqueries = 100;
my $chunk = 1000;

# -d for database name
# -p for database port
# -n for number of queries to issue
# -c for chunk size
# -t for index type
my %opt = ();
getopts('d:p:n:c:t:',\%opt);

if(defined $opt{d}){
  $db = $opt{d}
}
if(defined $opt{p}){
  $port = $opt{p}
}
if(defined $opt{t}){
  $type = $opt{t};
}
if(defined $opt{c}){
  $chunk = $opt{c}
}
if(defined $opt{n}){
  $nqueries = $opt{n}
}

print STDERR "db=".$db." at port ".$port.", index=".$type.",  Nqueries=".$nqueries.", chunk=".$chunk."\n";

my $dbh = DBI->connect("dbi:Pg:dbname=$db host=localhost port=$port");

for(my $d = 0; $d < $nqueries; $d++){
  my $q = "";
  my $start = $d*$chunk;
  my $end = ($d+1)*$chunk - 1;

  if ($type eq 'pg') {
    $q = "INSERT INTO test_pgsphere (id, point) (SELECT generate_series($start,$end), spoint(random()*2*pi(), (random()-0.5)*pi()));";
  } elsif ($type eq 'q3c') {
    $q = "INSERT INTO test_q3c (id, ra, dec) (SELECT generate_series($start,$end), random()*360, (random()-0.5)*180);"
  } elsif ($type eq 'haversine') {
    $q = "INSERT INTO test_haversine (id, ra, dec) (SELECT generate_series($start,$end), random()*360, (random()-0.5)*180);"
  } elsif ($type eq 'postgis') {
    $q = "INSERT INTO test_postgis (id, point) (SELECT generate_series($start,$end), st_geographyfromtext(concat('POINT(', random()*360-180, ' ', (random()-0.5)*180, ')')));"
  }

  $q = "EXPLAIN (ANALYZE ON, BUFFERS ON, FORMAT JSON) ".$q;

  print STDERR "$d/$nqueries start=$start $type\n";

  my $qr = $dbh->prepare($q);
  $qr->execute() or die "Error processing query: ".$dbh->errstr . "\n";
  my ($json) = $qr->fetchrow_array();

  my @h = @{decode_json($json)};

  my $time = $h[0]->{'Total Runtime'};
  my $blks_read = $h[0]->{'Plan'}->{'Shared Read Blocks'};
  my $blks_hit = $h[0]->{'Plan'}->{'Shared Hit Blocks'};

  print "$start $time $blks_read $blks_hit ".($blks_read+$blks_hit)."\n";
}
