#!/usr/bin/perl

open FH, "<", "FDO3.txt" or die $!;
open FH2, ">", "output3.txt" or die $!;

my $org='';
my $dir='';
my $tru='';
my $stf='';
my $mark1=0;
my $mark2=0;

while (<FH>){
    $_ =~ s/\r//g;
    next if ($_ =~ m/Copyright/gi);
    next if ($_ !~ /[a-zA-Z]/);
    next if ($_ =~ /note:/gi);
    next if ($_ =~ /Number/gi);
    next if ($_ =~ /^Staff/gi);
    next if ($_ =~ /[0-9] full-time/gi);
    next if ($_ =~ /[0-9] part-time/gi);
    next if ($_ =~ /[0-9] shared/gi);
    next if ($_ =~ /none/gi);
    if ($mark1 == 2)
    {
        if ($_ =~ /formerly/)
        {
            $org .= $_;
        }
        $mark1 = 0;
        $mark2 = 1;
    }
    if ($mark1 == 1)
    {
        $mark1 = 2;
        $org = $_;
    }
    if ($mark2 == 1)
    {
        if ( $_ =~ /^Officer/ or $_ =~ /Directors$/ )
        {
            $mark_dir = 1;
            $mark_tru = 0;
            $mark_stf = 0;
            $dir = '';
            next;
        }
        if ($_ =~ /^Key Staff/)
        {
            $mark_dir = 0;
            $mark_tru = 0;
            $mark_stf = 1;
            $stf = '';
            next;
        }        
        if ($_ =~ /^Trustee/)
        {
            $mark_dir = 0;
            $mark_stf = 0;
            $mark_tru = 1;
            $tru = '';
            next;
        }        
        if (($_ =~ /^Financial/ and $_ =~ /Data$/) or $_ =~ /Membership/)
        {
            $mark_dir = 0;
            $mark_stf = 0;
            $mark_tru = 0;
            next;
        }
    }
    if ($mark_dir == 1)
    {
        $dir .= $_;
    }
    if ($mark_stf == 1)
    {
        $stf .= $_;
    }
    if ($mark_tru == 1)
    {
        $tru .= $_;
    }
    if ( $_ =~ m/Want to see more grants for this grantmaker/gi )
    {
        $mark1 = 1;
        $mark2 = 0;
        $org =~ s/\n//g;
        $dir =~ s/\n/; /g;
        $stf=~ s/\n/; /g;
        $tru =~ s/\n/; /g;
        print FH2 "\"$org\"|\"$dir\"|\"$stf\"|\"$tru\"\n";
        $org = '';
        $dir = '';
        $stf = '';
        $tru = '';
    }
}

close FH;
close FH2;
exit;
