# TODO: move common of alias part to alias/function(how to-do?)

# NOTE: without argument +UVM_VERBOSITY=UVM_LOW, verbosity more then UVM_LOW

# Hi-lock: (("test_\\(transaction\\|read\\|write\\|multi_tr\\|arbitrage\\)" (0 '(:foreground "blue3" :weight bold))))
# Hi-lock: end


alias run_test_transaction {
    make compile
    make opt
    vsim cross_bar_tb_opt +UVM_TESTNAME=test_transaction +UVM_VERBOSITY=UVM_LOW -l test_transaction.log
    view wave
    do wave_cross_bar_tb.do
    run 1ms
}

alias run_test_write {
    make compile
    make opt
    vsim cross_bar_tb_opt +UVM_TESTNAME=test_write +UVM_VERBOSITY=UVM_LOW -l test_write.log
    view wave
    do wave_cross_bar_tb.do
    run 1ms
}

alias run_test_read {
    make compile
    make opt
    vsim cross_bar_tb_opt +UVM_TESTNAME=test_read +UVM_VERBOSITY=UVM_LOW
    view wave
    do wave_cross_bar_tb.do
    run 1ms
}

alias run_test_multi_tr {
    make compile
    make opt
    vsim cross_bar_tb_opt +UVM_TESTNAME=test_multi_tr +UVM_VERBOSITY=UVM_LOW -l test_multi_tr.log
    view wave
    do wave_cross_bar_tb.do
    run 1ms
}

alias run_test_arbitrage {
    make compile
    make opt
    vsim cross_bar_tb_opt +UVM_TESTNAME=test_arbitrage +UVM_VERBOSITY=UVM_LOW -l test_arbitrage.log
    view wave
    do wave_cross_bar_tb.do
    run 1ms
}
