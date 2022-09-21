#!/usr/bin/env perl

# Script to write UVM log file in more readable view: 'LOG' file to 'RPT' file

use warnings;
use strict;
use File::Basename qw(basename);
use POSIX qw(strftime);
use v5.10;

my $script_name = basename($0);

sub usage {
    print " Usage: $script_name <log_file>\n";
    print "   <log_file> - path to input log file\n";
}

{
    if (@ARGV != 1) {
        usage();
        die "ERROR! Not enough arguments!\n";
    }

    my $in_fname = shift(@ARGV);
    $_ = $in_fname;
    my $out_fname = /\.log$/ ? (s/log$/rpt/r) : ($_ .= '.rpt');
    my ($in_fh, $out_fh);
    open($in_fh, "<", $in_fname) or die "Can't open input file: $in_fname.$!\n";
    open($out_fh, ">", $out_fname) or die "Can't open output file: $out_fname. $!\n";

    my $part = 'header';
    while (<$in_fh>) {
        if (/Running test/) {
            $part = 'log';
        } elsif (/UVM Report Summary/) {
            $part = 'summary';
        }

        if ($part =~ 'header') {
            header_parser();
        } elsif ($part =~ 'log') {
            log_parser();
        } elsif ($part =~ 'summary') {
            summary_parser();
        }
        print $out_fh $_;
    }
    my $timestamp = strftime("%d/%m/%y %H:%M:%S", localtime);
    print $out_fh "\n(timestamp: $timestamp)\n";

    close($out_fh);
    close($in_fh);
    print "Write report: '$out_fname'.\n";

    exit 0;
}

sub header_parser {
    $_ = '';
}

sub log_parser {
    my $str = $_;
    if (/reporter \[RNTST\] Running test/) {
        s/.*(0:) reporter/$1/;
    } else {
        s/^#\s{0,3}//;
        if (/^UVM_/) {
            if (/.*@\s+(?<time>[0-9]+):\s+(?<item>\S+)\s+(?<tag>(\[[^\]]+\]))\s+(?<msg>.+)/) {
                my($time, $item, $tag, $msg) = ($+{time}, $+{item}, $+{tag}, $+{msg});
                if (defined $time) {
                    $_ = "$time $tag $item: $msg\n";
                }
            }
        }
    }
}

sub summary_parser {
    s/^# //;
}
