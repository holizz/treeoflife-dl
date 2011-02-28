#!/usr/bin/env perl

use strict;
use warnings;

use WWW::Curl::Easy;

##

my $zoom_level = 6;
my $x_max = 28;
my $y_max = 46;

my $uri = 'http://www.open2.net/treeoflife/treeOfLifePoster/TileGroup%d/%d-%d-%d.jpg';

##

sub dl {
  my $uri = shift(@_);
  my $zoom_level = shift(@_);
  my $x = shift(@_);
  my $y = shift(@_);
  our $tile_group;
  our $curl;

  my $while = 1;
  while ($while) {

    print "Finding $zoom_level-$x-$y.jpg\n";
    printf($uri."\n",$tile_group,$zoom_level,$x,$y);

    $curl->setopt(CURLOPT_URL, sprintf($uri,$tile_group,$zoom_level,$x,$y));
    my $response;
    $curl->setopt(CURLOPT_WRITEDATA,\$response);

    my $retcode = $curl->perform;

    die 'horribly' unless ($retcode == 0);

    if ($response !~ m[HTTP/1\.1 302 Found]) {
      print "Downloading...\n";

      # Strip header
      $response =~ s/^.*\r\n\r\n//s;

      # Open a file
      open my $f, ">$zoom_level-$x-$y.jpg";
      binmode $f;

      # Write some data
      print $f $response;

      close $f;
      print "Saved!\n";

      $while = 0;

    } else {
      print "Incrementing \$tile_group\n";
      # Try again with $tile_group++

      $tile_group++;
      $while = 1;
    }
  }

}

##

our $tile_group = 0;

our $curl = WWW::Curl::Easy->new;
$curl->setopt(CURLOPT_HEADER,1);

for (my $y = 0; $y <= $y_max; $y++) {
  for (my $x = 0; $x <= $x_max; $x++) {
    dl $uri, $zoom_level, $x, $y;
  }
}
