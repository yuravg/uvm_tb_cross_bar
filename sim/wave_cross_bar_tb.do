onerror {resume}
quietly WaveActivateNextPane {} 0


add wave -noupdate -divider {DUT}
add wave -noupdate {cross_bar_tb/DUT/*}
add wave -noupdate -divider {bus2bus_mux_0}
add wave -noupdate {cross_bar_tb/DUT/bus2bus_mux_0/*}

add wave -noupdate -divider {TB}
add wave -noupdate /cross_bar_tb/*

quietly WaveActivateNextPane
add wave -noupdate -divider {Master0}
add wave -noupdate {/cross_bar_tb/DUT/mbus[0]/*}
add wave -noupdate -divider {Master1}
add wave -noupdate {/cross_bar_tb/DUT/mbus[1]/*}


quietly WaveActivateNextPane
add wave -noupdate -divider {Slave 0}
add wave -noupdate {/cross_bar_tb/DUT/sbus[0]/*}
add wave -noupdate -divider {Slave 1}
add wave -noupdate {/cross_bar_tb/DUT/sbus[1]/*}


WaveRestoreCursors {{Cursor 1} {999448 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {550 ns}
