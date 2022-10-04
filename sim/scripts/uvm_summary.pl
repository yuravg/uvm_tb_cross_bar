#!/usr/bin/env perl

# Script to get summary from UVM-log files

use warnings;
use strict;
use Term::ANSIColor qw(:constants);
local $Term::ANSIColor::AUTOLOCAL = 1;
use v5.10;

my $test_log_mask = '^test.+log$';
my $test_src_mask = '^test.+svh$';
my $test_done_mask = '^# UVM_INFO.+TEST_DONE';
my $test_passed_mask = '^# UVM_INFO.+UVM TEST PASSED';
my $path2tests = '../../uvm_tb/tests';
my $path2logs = '..';

my $cnt_tests = get_files($path2tests, $test_src_mask);
my @log_files = get_files($path2logs, $test_log_mask);
my $cnt_logs = @log_files;
my $cnt_tests_done = match_in_files($test_done_mask, @log_files);
my $cnt_tests_passed = match_in_files($test_passed_mask, @log_files);

print "+-------------------------------------------------------+\n";
print "| Summary:                                              |\n";
print "+-------------------------------------------------------+\n";
print "| Expect tests / Find logs       = $cnt_tests / $cnt_logs\n";
print "| Tests done   / Tests PASSED    = $cnt_tests_done / $cnt_tests_passed\n";
print "+-------------------------------------------------------+\n";
print "| ";
if (tests_ok()) {
    print GREEN "Tests passed successfuly!\n";
} else {
    print RED "Tests failed!\n";
}
print "+-------------------------------------------------------+\n";

sub get_files {
    my ($dir, $mask) = @_;
    opendir my $dh, $dir or die "Can't open $dir: $!\n";
    my @files = grep {/$mask/} readdir $dh;
    foreach (@files) {
        $_ = "$dir/" . $_;
    }
    closedir $dh;
    return @files;
}

sub exist_string_in_file {
    my ($str, $fname) = @_;
    my $status = 0;
    open(my $fh, "<", $fname) or die "Can't open file: '$fname'. $!\n";
    while (<$fh>) {
        if (/$str/) {
            $status = 1;
            last;
        }
    }
    close($fh);
    return $status;
}

sub match_in_files {
    my ($str, @files) = @_;
    my $num = 0;
    foreach (@files) {
        if (exist_string_in_file($str, $_)) {
            $num++;
        }
    }
    return $num;
}

sub tests_ok {
    my $status = 0;
    if (($cnt_tests == $cnt_logs)
        and ($cnt_tests == $cnt_tests_done)
        and ($cnt_tests == $cnt_tests_passed)
        and ($cnt_tests > 0)) {
        $status = 1;
    }
}
