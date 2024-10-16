vlib work
vlog -f src_files.list  +cover -covercells
vsim -voptargs="+cover=bcfst+top/DUT" work.top -cover -classdebug -uvmcontrol=all
add wave /top/alsuif/*
#add wave /top/DUT/SVA_inst/*
coverage save alsu_test.ucdb -onexit -du work.ALSU
run -all
quit -sim
vcover report alsu_test.ucdb -details -all -output coverage_rpt.txt