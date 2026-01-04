#!/usr/bin/perl

use strict;
use Data::Dumper;

my %hash_billable_region;
my %hash_total_region;

while (<>) {
    my ($type, $region, $month, $calls) = split /,/, $_;
    $hash_total_region{$region}{$month} += $calls;
    if ($type =~ /^paid/ || $type =~ /^prepaid/){
        $type = "billable";
        $hash_billable_region{$type}{$region}{$month} += $calls;
    }
    
}
open (OUT, "> billable_summary.csv") or die "Cannot open billable_summary.csv: $!";
print OUT "date,type,region,billable_calls\n";
foreach my $type (keys %hash_billable_region){ 
    foreach my $r (sort keys %{$hash_billable_region{$type}}){
        foreach my $month (sort keys %{$hash_billable_region{$type}{$r}}) { 
            print  OUT $month, ",", $type, ",", $r, ",", $hash_billable_region{$type}{$r}{$month}, "\n"; 
            print ".";
        }
    }
}

close(OUT) or die "Cannot close billable_summary.csv: $!";

open (OUT2, "> total_region_summary.csv") or die "Cannot open total_region_summary.csv: $!";
print OUT2 "date,region,total_calls\n";
foreach my $r (sort keys %hash_total_region){
    foreach my $month (sort keys %{$hash_total_region{$r}}) { 
        print  OUT2 $month, ",", $r, ",", $hash_total_region{$r}{$month}, "\n"; 
        print ".";
    }
}
print "\n";
close(OUT2) or die "Cannot close total_region_summary.csv: $!";
