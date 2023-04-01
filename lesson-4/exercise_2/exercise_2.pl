# Define a global variable $x
use strict;
use warnings;

our $x = 1;
our $y = <> + 0;

sub fie {
    foo();
    $x = 0;
}

sub foo {
    local $x = 5;
}

if ($y > 0) {
    local $x = 4;
    fie();
} else {
    fie();
}

print "$x";
