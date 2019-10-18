set f_base_clock {200Mhz}

set_time_format \
    -unit ns    \
    -decimal_places 3

derive_clock_uncertainty

create_clock \
    -name {base_clock} \
    -period ${f_base_clock} \
    [get_ports {clk}]
