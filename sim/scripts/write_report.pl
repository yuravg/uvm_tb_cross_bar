#!/usr/bin/env perl

# Script to write UVM log file in more readable view: 'LOG' file to 'RPT' file

use warnings;
use strict;
use POSIX qw(strftime);
use 5.010;

my $script_name = $0;

sub usage {
    print " Usage: $script_name <log_file>\n";
    print "   <log_file> - path to input log file\n";
}

{
    if (@ARGV != 1) {
        usage();
        die "Not enough arguments!\n";
    }

    my $fname = $ARGV[0];

    open(LOG, "<", $fname)
        or die "Couldn't open '$fname' : $!";

    $_ = $fname;
    &rename_log();
    my $out_file = $_;
    open(RPT, ">", $out_file)
        or die "Couldn't open(output file) '$fname' : $!";

    &parser2rpt();

    close(LOG);
    close(RPT);
    print "Write report: '$out_file'.\n";

    exit 0;
}

sub rename_log {
    if (/\.log$/) {
        s/log$/rpt/;
    } else {
        $_ .= '.rpt';
    }
}


sub parser2rpt {
    my $part = 1;

    while (<LOG>) {
        if (/Running test/) {
            $part = 2;
        } elsif (/UVM Report Summary/) {
            $part = 3;
        }

        if ($part == 1) {
            &parser_header();
        } elsif ($part == 2) {
            &parser_log();
        } elsif ($part == 3) {
            &parser_summary();
        }
        print RPT $_;
    }
    my $timestamp = strftime("%d/%m/%y %H:%M:%S", localtime);
    print RPT "\n(timestamp: $timestamp)\n";
}

sub parser_header {
    $_ = '';
}

sub parser_log {
    my $str = $_;
    if (/reporter \[RNTST\] Running test/) {
        s/.*(0:) reporter/$1/;
    } else {
        s/^#//;
        if (/\s+\S+\s+\S+\s+\S+\s+(?<time>\S+)\s+(?<item>\S+)\s+(?<tag>\S+)\s+(?<msg>.+)/) {
            my($time, $item, $tag, $msg) = ($+{time}, $+{item}, $+{tag}, $+{msg});
            $item =~ s/uvm_test_top.//;
            $_ = "$time $tag $item: $msg\n";
        }
    }
}

sub parser_summary {
    s/^# //;
}
