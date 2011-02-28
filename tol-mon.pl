#!/usr/bin/env perl

use strict;
use warnings;

use WWW::Curl::Easy;

##

my $zoom_level = 6;
my $x_max = 28;
my $y_max = 46;

my $file = '%d-%d-%d.jpg';

my $cmd = 'montage -geometry 256x256+0+0 -tile '.($x_max+1).'x'.($y_max+1);

##

my @args = ();

for (my $y = 0; $y <= $y_max; $y++) {
  for (my $x = 0; $x <= $x_max; $x++) {
    push @args, sprintf $file, $zoom_level, $x, $y;
  }
}

push @args, 'out.jpg';

print "$cmd ".(join ' ', @args);
