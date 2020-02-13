#!/usr/bin/env tclsh

# Script to write UVM log file in more readable view
#
# Usage:
#  <sript_name> <uvm_transcript_file_name>
# Result: output file <uvm_transcript_file_name>.rpt
#
# to add not UVM message should use prefix "infomsg:"
# example: $display("infomsg: ...")

if {$argc != 1 || [lindex $argv 0] == ""} {
    puts "Error! Must be one input parameter for script!"
    exit 1
}

set in_file_name  "[lindex $argv 0]"
set out_file_name "$in_file_name.rpt"

if {![file exist $in_file_name]} {
    puts "Error! Can't find file \'$in_file_name\'!"
    exit 1
}

set p_in_file_name  [open $in_file_name r]
set p_out_file_name [open $out_file_name w]

set data       [read $p_in_file_name]
set split_data [split $data "\n"]
close $p_in_file_name

set sorted_data ""

set test_done 0

proc find_test_done {i} {
    global test_done
    set j [split $i " " ]
    if { [lindex $j 6] == "\[TEST_DONE\]" } {
        set test_done 1
    }
}

proc uvm_info_reporter { i } {
    global sorted_data
    set start [expr [string first "@" $i ] + 2]
    set d [string range $i $start [string length $i]]
    # cut world 'report'
    set start_cut [string first "r" $d]
    set d_begin [string range $d 0 [expr $start_cut - 1]]
    set d_end   [string range $d [expr $start_cut + 9] [string length $d]]
    set d "$d_begin$d_end"
    set sorted_data "$sorted_data\n$d"
    find_test_done $i
}

proc uvm_info_msg { i } {
    global sorted_data
    set j [split $i " " ]
    # str_dds, info_txt - deleted double space:
    set str_dds [lreplace "$i" 0 -1]
    set info_txt ""
    for {set k 7} {$k<[llength $str_dds]} {incr k} {
        set info_txt "$info_txt [lindex $str_dds $k]"
    }
    set time [lindex $j 4]
    set module_label [lindex $j 5]
    set module_label [string range $module_label 13 [string length $j]]
    set id [lindex $j 6]
    set xx [lindex $j 7]
    set d "$time $id $module_label:$info_txt"
    set sorted_data "$sorted_data\n$d"
    find_test_done $i
}

proc detected_uvm_info { i } {
    if { [lindex $i 4] == "reporter" || [lindex $i 5] == "reporter" } {
        uvm_info_reporter $i
    } else {
        if { [lindex $i 3] == "@" } {
            uvm_info_msg $i
        }
    }
}

proc detected_end_msg { i } {
    global sorted_data
    if { [lindex $i 3] == "@" } {
        detected_uvm_info $i
    } else {
        set d [string range $i 2 [string length $i]]
        set sorted_data "$sorted_data\n$d"
    }
}

proc detected_uvm_warn { i } {
    global sorted_data
    set d   [string range $i 2 [string length $i]]
    set sorted_data "$sorted_data\n$d"
}

proc print_all_after_this_event { i } {
    global test_done
    set test_done 1
    global sorted_data
    set d   [string range $i 2 [string length $i]]
    set sorted_data "$sorted_data\n$d"
}

proc user_defined_msg { i } {
    global sorted_data
    set sorted_data "$sorted_data\n$i"
}

foreach str $split_data {
    global test_done

    # replace all symbol: " to '
    regsub -all -nocase {[\"]} $str "'" str

    set i [split $str " "]

    if { !$test_done } {
        if { [lindex $i 1] == "UVM_INFO" } {
            detected_uvm_info $str
        }
        if { [lindex $i 1] == "UVM_WARNING" } {
            detected_uvm_warn $str
        }
        if { [lindex $i 1] == "UVM_ERROR" } {
            detected_uvm_warn $str
        }
        if { [lindex $i 1] == "UVM_FATAL" } {
            detected_uvm_warn $str
        }
        if { [lindex $i 2]=="UVM" || [lindex $i 3]=="Report" || [lindex $i 4]=="Summary"} {
            set test_done 1
            detected_end_msg $str
        }
        if { [lindex $i 2] == "Fatal:" } {
            print_all_after_this_event $str
        }
        if { [lindex $i 1] == "infomsg:" } {
            user_defined_msg $str
        }
    } else {
        detected_end_msg $str
    }
}

set generation_time [clock format [clock sec] -format "%d/%m/%y; %H:%M:%S"]
set msg \
"$sorted_data
(time write log: $generation_time)
"

puts $p_out_file_name $msg
close $p_out_file_name

puts "Write report: '$out_file_name'."
