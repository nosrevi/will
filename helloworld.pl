#!/usr/bin/perl
for (1 .. 5){
    print "what's ur name?\n";
}
my $name = <STDIN>;
chomp($name);
print "my name is: $name\n";

